use crate::constants::*;
use flatbuffers::{FlatBufferBuilder, WIPOffset};

pub fn fb_vec32<'b>(
    fbb: &mut FlatBufferBuilder<'b>,
    arr: &Sized32Bytes,
) -> WIPOffset<flatbuffers::Vector<'b, u8>> {
    fbb.create_vector(arr)
}

pub fn fb_vec64<'b>(
    fbb: &mut FlatBufferBuilder<'b>,
    arr: &Sized64Bytes,
) -> WIPOffset<flatbuffers::Vector<'b, u8>> {
    fbb.create_vector(arr)
}

pub fn fb_vec256<'b>(
    fbb: &mut FlatBufferBuilder<'b>,
    arr: &Sized256Bytes,
) -> WIPOffset<flatbuffers::Vector<'b, u8>> {
    fbb.create_vector(arr)
}

pub fn slice32(v: &[u8]) -> Option<Sized32Bytes> {
    v.try_into().ok()
}
pub fn slice64(v: &[u8]) -> Option<Sized64Bytes> {
    v.try_into().ok()
}
pub fn slice256(v: &[u8]) -> Option<Sized256Bytes> {
    v.try_into().ok()
}
