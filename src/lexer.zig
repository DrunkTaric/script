const expectEqualDeep = @import("std").testing.expectEqualDeep;

const Token = union(enum) {
    ILLEGAL,
    EOF,
    EQUAL,
    PLUS,
    COMMA,
    SEMICOLON,
    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,
};

const Lexer = struct {
    const Self = @This();

    ch: u8 = 0,
    position: usize = 0,
    readPosition: usize = 0,
    input: []const u8,

    fn init(input: []const u8) Lexer {
        var lex = Self{ .input = input };
        lex.readChar();
        return lex;
    }

    fn readChar(self: *Self) void {
        if (self.readPosition >= self.input.len) {
            self.ch = 0;
        } else {
            self.ch = self.input[self.readPosition];
        }

        self.position = self.readPosition;
        self.readPosition += 1;
    }

    fn nextToken(self: *Self) Token {
        const token: Token = switch (self.ch) {
            0 => .EOF,
            '=' => .EQUAL,
            '+' => .PLUS,
            ',' => .COMMA,
            ';' => .SEMICOLON,
            '(' => .LPAREN,
            ')' => .RPAREN,
            '{' => .LBRACE,
            '}' => .RBRACE,
            else => .ILLEGAL,
        };

        self.readChar();

        return token;
    }
};

test "test getnextToken()" {
    const input = "=+(){},;";
    var lex = Lexer.init(input);
    const tokens = [_]Token{ .EQUAL, .PLUS, .LPAREN, .RPAREN, .LBRACE, .RBRACE, .COMMA, .SEMICOLON };
    for (tokens) |token| {
        const tok = lex.nextToken();
        try expectEqualDeep(token, tok);
    }
}
