const std = @import("std");
const lexer = @import("./lexer.zig");
test {
    _ = @import("./lexer.zig");
}

pub fn main() !void {
    const input =
        \\let x = 5;
        \\let y = 10;
        \\method (i < 20) export true;
        \\//lebron is real//let x = 1 / 2;
    ;
    var lex = lexer.Lexer.init(input);
}
