const std = @import("std");
const Allocator = std.mem.Allocator;

pub const Types = enum {
    call,
    literal,
    identifier,
    if_clause,
    if_statment,
    else_clause,
    else_statment,
    return_statment,
};

pub const Node = struct {
    const Self = @This();

    allocator: Allocator,
    type: Types,
    data: T,

    fn init(allocator: Allocator, nodeType: Types, data: T) !*Self {
        const ptr = try allocator.create(Self);
        ptr.* = .{ .allocator = allocator, .type = nodeType, .data = data };
        return ptr;
    }

    fn change(self: *Self, data: T) void {
        self.data = data;
    }

    fn dump(self: *Self) void {
        std.debug.print("Node of address: {*}\nHave type of: {any}\nHave data: {any}", .{ &self, self.type, self.data });
    }

    fn free(self: *Self) void {
        self.allocator.destroy(self);
    }
};

const Program = struct {
    allocator: Allocator,
    nodes: std.ArrayList(*@TypeOf(Node)),

    fn init() *Program {
        const allocator = std.heap.page_allocator;
        const program = try allocator.create(Program);
        program.* = Program{ .allocator = allocator, .nodes = std.ArrayList(*Node).init(allocator) };
        return program;
    }

    fn free(self: *Program) void {
        self.allocator.destroy(self);
    }
};

pub fn main() !void {
    _ = Program.init();
}
