# .code.pit

## Header

```zig
const hash_type = u8[32]; // SHA-256

const pit_header_common = struct {
  magic u32, // 0x7f, 0x50 (P), 0x49(I), 0x54 (T)
  file_version u32, // Must be Big Edian
};


const pit_header_v0 = struct {
  common pit_header_common,
  edian_class u8, // 1 for little, 2 for big
  tmp0 u8,
  obj_block_size u16, // Work in blocks, not bytes
  index_start u32,
  index_size u32,
  index_hash u8[32],
  obj_db_start u32,
  obj_db_block_size u32,
};

const index_data = struct {
  hash u8[32],
  block u32,
  block_count u32,
};

const tree_K = 8;

// Index is a b-tree
const index_node = struct {
  internal index_data[tree_K],
};

```
