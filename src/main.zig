const std = @import("std");
const lexer = @import("./lexer.zig");

pub fn main() !void {
    var i: u8 = 0;
    const input =
        \\let x = "lebron"
    ;
    var lex = lexer.Lexer.init(input);
    while (lex.position <= input.len) : (i += 1) {
        std.debug.print("Current Token: {?}\n", .{lex.nextToken()});
    }
}
