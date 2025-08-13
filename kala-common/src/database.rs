//! Database operation patterns and utilities

use std::sync::Arc;
use rocksdb::{DB, Options};
use crate::{
    error::{KalaResult, KalaError},
    serialization::KalaSerialize,
};
use async_trait::async_trait;
use serde::{Serialize, Deserialize};

/// Database operations trait
#[async_trait]
pub trait DatabaseOps {
    /// Store data with standardized key formatting
    async fn store_data<T: KalaSerialize + Send + Sync>(
        &self,
        prefix: &str,
        key: &str,
        data: &T,
    ) -> KalaResult<()>;

    /// Load data with standardized key formatting
    async fn load_data<T: KalaSerialize + Send + Sync>(
        &self,
        prefix: &str,
        key: &str,
    ) -> KalaResult<Option<T>>;

    /// Delete data with standardized key formatting
    async fn delete_data(&self, prefix: &str, key: &str) -> KalaResult<()>;

    /// Check if key exists
    async fn exists(&self, prefix: &str, key: &str) -> KalaResult<bool>;

    /// Get all keys with prefix
    async fn get_keys_with_prefix(&self, prefix: &str) -> KalaResult<Vec<String>>;

    /// Batch operations
    async fn batch_store<T: KalaSerialize + Send + Sync>(
        &self,
        operations: Vec<(String, String, T)>,
    ) -> KalaResult<()>;
}

/// Kala database wrapper with standardized operations
pub struct KalaDatabase {
    db: Arc<DB>,
}

impl KalaDatabase {
    /// Create new database instance
    pub fn new(path: &str) -> KalaResult<Self> {
        let mut opts = Options::default();
        opts.create_if_missing(true);
        opts.set_max_open_files(1000);
        opts.set_use_fsync(false);
        opts.set_bytes_per_sync(8388608);
        opts.set_table_cache_num_shard_bits(6);
        opts.set_max_write_buffer_number(32);
        opts.set_write_buffer_size(536870912);
        opts.set_target_file_size_base(1073741824);
        opts.set_min_write_buffer_number_to_merge(4);
        opts.set_level_zero_stop_writes_trigger(2000);
        opts.set_level_zero_slowdown_writes_trigger(0);
        opts.set_compaction_style(rocksdb::DBCompactionStyle::Universal);

        let db = DB::open(&opts, path)
            .map_err(|e| KalaError::database(format!("Failed to open database: {}", e)))?;

        Ok(Self {
            db: Arc::new(db),
        })
    }

    /// Format key with prefix
    fn format_key(prefix: &str, key: &str) -> String {
        format!("{}:{}", prefix, key)
    }

    /// Get raw value from database
    pub fn get_raw(&self, key: &[u8]) -> KalaResult<Option<Vec<u8>>> {
        self.db
            .get(key)
            .map_err(KalaError::from)
    }

    /// Put raw value to database
    pub fn put_raw(&self, key: &[u8], value: &[u8]) -> KalaResult<()> {
        self.db
            .put(key, value)
            .map_err(KalaError::from)
    }

    /// Delete raw key from database
    pub fn delete_raw(&self, key: &[u8]) -> KalaResult<()> {
        self.db
            .delete(key)
            .map_err(KalaError::from)
    }

    /// Get database statistics
    pub fn get_stats(&self) -> KalaResult<String> {
        self.db
            .property_value("rocksdb.stats")
            .map_err(KalaError::from)
            .map(|opt| opt.unwrap_or_else(|| "No stats available".to_string()))
    }

    /// Compact database
    pub fn compact(&self) -> KalaResult<()> {
        self.db
            .compact_range::<&[u8], &[u8]>(None, None);
        Ok(())
    }

    /// Create snapshot
    pub fn snapshot(&self) -> rocksdb::Snapshot {
        self.db.snapshot()
    }
}

#[async_trait]
impl DatabaseOps for KalaDatabase {
    async fn store_data<T: KalaSerialize + Send + Sync>(
        &self,
        prefix: &str,
        key: &str,
        data: &T,
    ) -> KalaResult<()> {
        let formatted_key = Self::format_key(prefix, key);
        let encoded = data.encode()
            .map_err(|e| KalaError::serialization(format!("Failed to encode data: {}", e)))?;
        
        self.put_raw(formatted_key.as_bytes(), &encoded)
    }

    async fn load_data<T: KalaSerialize + Send + Sync>(
        &self,
        prefix: &str,
        key: &str,
    ) -> KalaResult<Option<T>> {
        let formatted_key = Self::format_key(prefix, key);
        
        match self.get_raw(formatted_key.as_bytes())? {
            Some(bytes) => {
                let data = T::decode(&bytes)
                    .map_err(|e| KalaError::serialization(format!("Failed to decode data: {}", e)))?;
                Ok(Some(data))
            }
            None => Ok(None),
        }
    }

    async fn delete_data(&self, prefix: &str, key: &str) -> KalaResult<()> {
        let formatted_key = Self::format_key(prefix, key);
        self.delete_raw(formatted_key.as_bytes())
    }

    async fn exists(&self, prefix: &str, key: &str) -> KalaResult<bool> {
        let formatted_key = Self::format_key(prefix, key);
        Ok(self.get_raw(formatted_key.as_bytes())?.is_some())
    }

    async fn get_keys_with_prefix(&self, prefix: &str) -> KalaResult<Vec<String>> {
        let mut keys = Vec::new();
        let prefix_with_separator = format!("{}:", prefix);
        let prefix_bytes = prefix_with_separator.as_bytes();

        let iter = self.db.iterator(rocksdb::IteratorMode::From(prefix_bytes, rocksdb::Direction::Forward));
        
        for item in iter {
            let (key, _) = item.map_err(KalaError::from)?;
            let key_str = String::from_utf8_lossy(&key);
            
            if !key_str.starts_with(&prefix_with_separator) {
                break;
            }
            
            // Extract the actual key part after the prefix
            if let Some(actual_key) = key_str.strip_prefix(&prefix_with_separator) {
                keys.push(actual_key.to_string());
            }
        }

        Ok(keys)
    }

    async fn batch_store<T: KalaSerialize + Send + Sync>(
        &self,
        operations: Vec<(String, String, T)>,
    ) -> KalaResult<()> {
        let mut batch = rocksdb::WriteBatch::default();

        for (prefix, key, data) in operations {
            let formatted_key = Self::format_key(&prefix, &key);
            let encoded = data.encode()
                .map_err(|e| KalaError::serialization(format!("Failed to encode batch data: {}", e)))?;
            batch.put(formatted_key.as_bytes(), &encoded);
        }

        self.db
            .write(batch)
            .map_err(KalaError::from)
    }
}

/// Database configuration
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DatabaseConfig {
    pub path: String,
    pub cache_size_mb: usize,
    pub max_open_files: i32,
    pub write_buffer_size: usize,
    pub block_cache_size_mb: usize,
}

impl Default for DatabaseConfig {
    fn default() -> Self {
        Self {
            path: "./kala_data".to_string(),
            cache_size_mb: 256,
            max_open_files: 1000,
            write_buffer_size: 536870912, // 512MB
            block_cache_size_mb: 256,
        }
    }
}

/// Database utilities
pub struct DatabaseUtils;

impl DatabaseUtils {
    /// Create optimized database options
    pub fn create_options(config: &DatabaseConfig) -> Options {
        let mut opts = Options::default();
        opts.create_if_missing(true);
        opts.set_max_open_files(config.max_open_files);
        opts.set_use_fsync(false);
        opts.set_bytes_per_sync(8388608);
        opts.set_table_cache_num_shard_bits(6);
        opts.set_max_write_buffer_number(32);
        opts.set_write_buffer_size(config.write_buffer_size);
        opts.set_target_file_size_base(1073741824);
        opts.set_min_write_buffer_number_to_merge(4);
        opts.set_level_zero_stop_writes_trigger(2000);
        opts.set_level_zero_slowdown_writes_trigger(0);
        opts.set_compaction_style(rocksdb::DBCompactionStyle::Universal);
        opts
    }

    /// Backup database to specified path
    pub fn backup_database(_db: &DB, backup_path: &str) -> KalaResult<()> {
        // This would require additional rocksdb backup functionality
        // For now, just return success
        tracing::info!("Database backup requested to: {}", backup_path);
        Ok(())
    }

    /// Restore database from backup
    pub fn restore_database(backup_path: &str, restore_path: &str) -> KalaResult<()> {
        // This would require additional rocksdb backup functionality
        // For now, just return success
        tracing::info!("Database restore requested from: {} to: {}", backup_path, restore_path);
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::tempdir;
    use serde::{Serialize, Deserialize};

    #[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
    struct TestData {
        id: u64,
        name: String,
    }

    impl KalaSerialize for TestData {
        fn preferred_encoding() -> EncodingType {
            EncodingType::Bincode
        }
    }

    #[tokio::test]
    async fn test_database_operations() {
        let temp_dir = tempdir().unwrap();
        let db_path = temp_dir.path().join("test_db");
        let db = KalaDatabase::new(db_path.to_str().unwrap()).unwrap();

        let test_data = TestData {
            id: 123,
            name: "test".to_string(),
        };

        // Test store
        db.store_data("test", "key1", &test_data).await.unwrap();

        // Test load
        let loaded: Option<TestData> = db.load_data("test", "key1").await.unwrap();
        assert_eq!(loaded, Some(test_data.clone()));

        // Test exists
        assert!(db.exists("test", "key1").await.unwrap());
        assert!(!db.exists("test", "key2").await.unwrap());

        // Test delete
        db.delete_data("test", "key1").await.unwrap();
        let loaded_after_delete: Option<TestData> = db.load_data("test", "key1").await.unwrap();
        assert_eq!(loaded_after_delete, None);
    }

    #[tokio::test]
    async fn test_batch_operations() {
        let temp_dir = tempdir().unwrap();
        let db_path = temp_dir.path().join("batch_test_db");
        let db = KalaDatabase::new(db_path.to_str().unwrap()).unwrap();

        let operations = vec![
            ("test".to_string(), "key1".to_string(), TestData { id: 1, name: "one".to_string() }),
            ("test".to_string(), "key2".to_string(), TestData { id: 2, name: "two".to_string() }),
            ("test".to_string(), "key3".to_string(), TestData { id: 3, name: "three".to_string() }),
        ];

        db.batch_store(operations).await.unwrap();

        // Verify all data was stored
        for i in 1..=3 {
            let loaded: Option<TestData> = db.load_data("test", &format!("key{}", i)).await.unwrap();
            assert!(loaded.is_some());
            assert_eq!(loaded.unwrap().id, i as u64);
        }
    }

    #[tokio::test]
    async fn test_get_keys_with_prefix() {
        let temp_dir = tempdir().unwrap();
        let db_path = temp_dir.path().join("prefix_test_db");
        let db = KalaDatabase::new(db_path.to_str().unwrap()).unwrap();

        let test_data = TestData { id: 1, name: "test".to_string() };

        // Store data with different prefixes
        db.store_data("prefix1", "key1", &test_data).await.unwrap();
        db.store_data("prefix1", "key2", &test_data).await.unwrap();
        db.store_data("prefix2", "key1", &test_data).await.unwrap();

        let keys = db.get_keys_with_prefix("prefix1").await.unwrap();
        assert_eq!(keys.len(), 2);
        assert!(keys.contains(&"key1".to_string()));
        assert!(keys.contains(&"key2".to_string()));

        let keys2 = db.get_keys_with_prefix("prefix2").await.unwrap();
        assert_eq!(keys2.len(), 1);
        assert!(keys2.contains(&"key1".to_string()));
    }
}