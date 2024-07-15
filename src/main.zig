const std = @import("std");
const c = @cImport({
    @cInclude("sqlite3.h");
});
const hash_digest = std.crypto.hash.sha2.Sha256;

/// Basic sqlite3 wrapper
const DB = struct {
    db: *c.sqlite3,

    fn init(db: *c.sqlite3) DB {
        return .{ .db = db };
    }

    fn open(path_to_db: [:0]const u8) !DB {
        var c_db: ?*c.sqlite3 = undefined;
        if (c.SQLITE_OK != c.sqlite3_open(path_to_db, &c_db)) {
            std.debug.print("Unable to open database: {s}\n", .{c.sqlite3_errmsg(c_db)});
            return error.execError;
        }
        return .{ .db = c_db.? };
    }

    fn close(self: DB) void {
        _ = c.sqlite3_close(self.db);
    }

    fn execute(self: DB, query: [:0]const u8) !void {
        var errmsg: [*c]u8 = undefined;
        if (c.SQLITE_OK != c.sqlite3_exec(self.db, query, null, null, &errmsg)) {
            defer c.sqlite3_free(errmsg);
            std.debug.print("Exec query failed: {s}\n", .{errmsg});
            return error.execError;
        }
        return;
    }
};

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
