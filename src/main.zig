const std = @import("std");
const c = @cImport({
    @cInclude("sqlite3.h");
});
const hash_digest = std.crypto.hash.sha2.Sha256;

pub fn main() !void {
    const version = c.sqlite3_libversion();
    std.debug.print("libsqlite3 version is {s}\n", .{version});
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
