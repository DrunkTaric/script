const std = @import("std");
const Lexer = @import("./lexer/lexer.zig").Lexer;
const Parser = @import("./parser/parser.zig").Parser;

test {
    _ = @import("./lexer.zig");
}

pub fn main() !void {
    const input =
        \\let x = 5;
        \\let y = 10;
        \\let x = 1 / 2;
    ;
    var lex = Lexer.init(input);
    var p = Parser.init(&lex);
    while (p.currentToken != .EOF) {
        const token = p.parseToken();
        std.debug.print("Exported Token: {any}\n", .{token});
    }
}
