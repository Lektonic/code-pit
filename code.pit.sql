-- SQLite code to create .code.pit tables

create table blobs (
    hash integer primary key not null,
    type text,
    author text,
    timestamp integer,
    compression text,
    content blob not null
) strict;

create table heads (
    ref_hash integer not null,
    name text unique not null,
    foreign key (ref_hash) references blobs(hash)
) strict;

create unique index head_name on heads(name);

create table tags (
    ref_hash integer not null,
    name text unique not null,
    foreign key (ref_hash) references blobs(hash)
) strict;
create unique index tag_names on tags(name);

create table commits (
    comment_hash integer not null,
    tree_hash integer,
    parent_hash integer,
    foreign key (comment_hash) references blobs(hash),
    foreign key (tree_hash) references blobs(hash),
    foreign key (parent_hash) references blobs(hash)
) strict;
create unique index commit_hashes on commits(comment_hash);
