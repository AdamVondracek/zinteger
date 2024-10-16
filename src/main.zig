const std = @import("std");
const Integer = @import("integer.zig").Integer;
const test_alloc = std.testing.allocator;

test "APA Int: init/deinit" {
    var x = try Integer.init(999, test_alloc);
    defer x.deinit();
}

test "APA Int: init form u64" {
    var x = try Integer.from_u64(123456, test_alloc);
    defer x.deinit();
}

test "APA Int: EXTEND" {
    var x = try Integer.from_u64(123456, test_alloc);
    defer x.deinit();
    try x.extend();
    x.print();
}

test "APA Int: add without overflow" {
    var x = try Integer.from_u64(100, test_alloc);
    defer x.deinit();
    var y = try Integer.from_u64(200, test_alloc);
    defer y.deinit();
    try x.add(y);
    x.print();
}

test "APA Int: add with overflow" {
    const big = std.math.maxInt(u64);
    var x = try Integer.from_u64(big, test_alloc);
    defer x.deinit();
    var y = try Integer.from_u64(big, test_alloc);
    defer y.deinit();
    try x.add(y);
    x.print();
}
