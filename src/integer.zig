const std = @import("std");
const Allocator = std.mem.Allocator;

pub const Integer = struct {
    allocator: Allocator,
    size: usize,
    sign: bool,
    chunks: []u64,

    pub fn init(size: usize, allocator: Allocator) !Integer {
        const retval = Integer{
            .allocator = allocator,
            .size = size,
            .sign = false,
            .chunks = try allocator.alloc(u64, size),
        };

        for (0..size) |i| {
            retval.chunks[i] = 0;
        }
        return retval;
    }

    pub fn deinit(self: Integer) void {
        self.allocator.free(self.chunks);
    }

    pub fn print(self: Integer) void {
        for (self.chunks, 0..) |elem, i| {
            std.debug.print("{} {}\n", .{ i, elem });
        }
    }

    pub fn from_u64(num: u64, allocator: Allocator) !Integer {
        var integer = try Integer.init(1, allocator);
        integer.chunks[0] = num;
        return integer;
    }

    pub fn extend(integer: *Integer) !void {
        var new_chunks = try integer.allocator.alloc(u64, integer.size + 1);
        @memcpy(new_chunks[0..integer.size], integer.chunks);
        integer.allocator.free(integer.chunks);
        integer.chunks = new_chunks;
        integer.chunks[integer.size] = 0;
        integer.size += 1;
    }

    pub fn add(self: *Integer, other: Integer) !void {
        if (self.size >= other.size) {
            var carry: u64 = 0;
            for (0..other.size) |i| {
                var overflow = @addWithOverflow(self.chunks[i], carry);
                self.chunks[i] = overflow[0];
                carry = overflow[1]; // sets it to 0 if no overflow
                overflow = @addWithOverflow(self.chunks[i], other.chunks[i]);
                self.chunks[i] = overflow[0];
                carry += overflow[1];
            }
            if (carry != 0) {
                try self.extend();
                self.chunks[self.size - 1] = carry;
            }
        } else {
            std.debug.print("Other is bigger than self", .{});
        }
    }
};
