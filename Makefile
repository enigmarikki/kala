# Kala Development Makefile
# Run `make help` to see available commands

.PHONY: help build build-release test test-unit test-all fmt clippy lint check deny doc clean install-tools pr

# Default target
.DEFAULT_GOAL := help

##@ Build

build: ## Build all crates in debug mode
	cargo build --workspace --all-features

build-release: ## Build all crates in release mode
	cargo build --workspace --all-features --release

##@ Testing

test: test-unit ## Run tests (alias for test-unit)

test-unit: ## Run unit tests
	cargo test --workspace --all-features

test-all: ## Run all tests including ignored
	cargo test --workspace --all-features -- --include-ignored

bench: ## Run benchmarks
	cargo bench --workspace

##@ Code Quality

fmt: ## Format code using rustfmt
	cargo fmt --all

fmt-nightly: ## Format code using nightly rustfmt (more features)
	cargo +nightly fmt --all

fmt-check: ## Check code formatting without changes
	cargo fmt --all -- --check

clippy: ## Run clippy lints
	cargo clippy --workspace --all-features --all-targets -- -D warnings

clippy-fix: ## Run clippy and apply automatic fixes
	cargo clippy --workspace --all-features --all-targets --fix --allow-dirty --allow-staged

lint: fmt clippy ## Run all linting (format + clippy)

lint-check: fmt-check clippy ## Check all linting without changes

##@ Security & Dependencies

deny: ## Run cargo-deny checks (licenses, security, sources)
	cargo deny check

deny-licenses: ## Check dependency licenses only
	cargo deny check licenses

deny-bans: ## Check banned dependencies only
	cargo deny check bans

deny-advisories: ## Check security advisories only
	cargo deny check advisories

##@ Documentation

doc: ## Generate documentation
	cargo doc --workspace --all-features --no-deps

doc-open: ## Generate and open documentation
	cargo doc --workspace --all-features --no-deps --open

##@ Pre-commit / CI

check: ## Quick check (compile without building)
	cargo check --workspace --all-features --all-targets

pr: lint-check test deny ## Run full PR checks (lint, test, deny)

pre-commit: fmt-check clippy check ## Run pre-commit checks

##@ Utilities

clean: ## Clean build artifacts
	cargo clean

update: ## Update dependencies
	cargo update

tree: ## Show dependency tree
	cargo tree --workspace

outdated: ## Show outdated dependencies
	cargo outdated --workspace

##@ Setup

install-tools: ## Install required development tools
	@echo "Installing development tools..."
	rustup component add rustfmt --toolchain nightly
	rustup component add clippy
	cargo install cargo-deny
	cargo install cargo-outdated
	cargo install cargo-nextest
	@echo "Tools installed successfully!"

install-hooks: ## Install git hooks
	@echo "Installing git hooks..."
	@cp scripts/pre-commit .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "Git hooks installed!"

##@ Help

help: ## Show this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
