# .code.pit

## Hash Table (Metadata)

### Columns

- Hash
- Type
- Timestamp
- Author

### Hash Types

- Blob
- Tree
- Commit

---

## Blob Table (Object)

### Columns

- Hash
- Compression
- Content

### Compression Types

- Zlib / DEFLATE
- None
- zstd:{Blob hash}

### Indexes

- Hash

---

## Annotation Table

### Columns

- Hash
- Timestamp
- Author
- Content

### Index

- Hash

### Ref Types

- Tree
- Blob

---

## Tag Table

### Columns

- Name
- Ref Type
- Ref Hash

### Ref Types

- Annotation
- Tree
- Blob

---

## Refs Table

### Columns

- name
- object hash

### Indexes

- Name

---

## Commit Table

### Columns

- Commit Hash
- Tree Hash
- Parent Hash
- Author
- Timestamp
- Message

### Indexes

- Tree Hash
- Parent Hash
- Author

---

# .local.pit

## Config Table

### Columns

- Key
- Value

## Remotes Table

## Hooks Table

## Staging Table

## Stash Table

- Refer to `.code.pit` object table.
