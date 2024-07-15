const std = @import("std");
const c = @cImport({
    @cInclude("sqlite3.h");
});
const hash_digest = std.crypto.hash.sha2.Sha256;

pub fn find_pit_file() []u8 {}

pub fn open_code_db(path_to_db: [*c]const u8) ?*c.sqlite3 {
    var c_db: ?*c.sqlite3 = undefined;
    if (c.SQLITE_OK != c.sqlite3_open(path_to_db, &c_db)) {
        std.debug.print("Unable to open database: {s}\n", .{c.sqlite3_errmsg(c_db)});
        return c_db;
    }
    return c_db;
}

const code_pit_init_scrpt = @embedFile("code-pit.init.sql");

pub fn main() !void {
    const version = c.sqlite3_libversion();
    std.debug.print("libsqlite3 version is {s}\n", .{version});
    std.debug.print(code_pit_init_scrpt, .{});
}

pub fn hash_file(name: []u8) ![hash_digest.digest_length]u8 {
    const hf = try std.fs.cwd().openFile(name, .{});
    defer hf.close();

    const hfr = hf.reader();

    return hash_reader(hfr);
}

pub fn hash_reader(reader: std.Reader) ![hash_digest.digest_length]u8 {
    var hash = hash_digest.init(.{});
    var buf: [4096]u8 = undefined;
    var n = try reader.read(&buf);
    while (n != 0) {
        hash.update(buf[0..n]);
        n = try reader.read(&buf);
    }

    return hash_digest.finalResult();
}
