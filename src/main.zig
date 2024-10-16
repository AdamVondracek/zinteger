const std = @import("std");
const Integer = @import("integer.zig").Integer;

test "APA Int: init/deinit" {
    var x = try Integer.init(69, std.testing.allocator);
    defer x.deinit();
}

test "APA Int: init form u64" {
    var x = try Integer.from_u64(69696969, std.testing.allocator);
    defer x.deinit();
}

test "APA Int: EXTEND" {
    var x = try Integer.from_u64(69696969, std.testing.allocator);
    defer x.deinit();
    try x.extend();
    x.print();
}

test "APA Int: add without overflow" {
    var x = try Integer.from_u64(69, std.testing.allocator);
    defer x.deinit();
    var y = try Integer.from_u64(420, std.testing.allocator);
    defer y.deinit();
    try x.add(y);
    x.print();
}

test "APA Int: add with overflow" {
    const big = std.math.maxInt(u64);
    var x = try Integer.from_u64(big, std.testing.allocator);
    defer x.deinit();
    var y = try Integer.from_u64(big, std.testing.allocator);
    defer y.deinit();
    try x.add(y);
    x.print();
}
