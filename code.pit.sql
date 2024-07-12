-- SQLite code to create .code.pit tables

create table blobs (
    hash blob primary key not null,
    type text,
    author text,
    timestamp integer,
    compression text,
    content blob not null
) strict;

create table heads (
    ref_hash blob not null,
    name text unique not null,
    foreign key (ref_hash) references blobs(hash)
) strict;

create unique index head_name on heads(name);

create table tags (
    ref_hash blob not null,
    name text unique not null,
    foreign key (ref_hash) references blobs(hash)
) strict;
create unique index tag_names on tags(name);

create table commits (
    comment_hash blob not null,
    tree_hash blob,
    parent_hash blob,
    foreign key (comment_hash) references blobs(hash),
    foreign key (tree_hash) references blobs(hash),
    foreign key (parent_hash) references blobs(hash)
) strict;
create unique index commit_hashes on commits(comment_hash);

create table annotation (
    comment_hash blob unique not null,
    parent_hash blob,
    ref_hash blob not null,
    foreign key (comment_hash) references blobs(hash),
    foreign key (ref_hash) references blobs(hash)
) strict;
create unique index annotation_hashes on annotation(comment_hash);
create unique index annotation_parents on annotation(parent_hash);
