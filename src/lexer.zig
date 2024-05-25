const std = @import("std");

const Token = union(enum) {
    // Types
    NUMBER: []const u8,
    STRING: []const u8,
    BOOLEAN,
    // Keywords
    LET,
    IDENTIFIER,
    FUNCTION,
    // Operators
    EQUAL,
    PLUS,
    MINUS,
    POWER, // WIP
    MULTIPLY,
    DEVIDE,
    NOTEQUAL, // WIP
    // Logic
    LESSTHAN,
    GREATERTHAN,
    // Delimiters
    COMMA,
    SEMICOLON,

    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,

    QUOTES,
    // Other
    BANG, // WIP
    EOF,
    ILLEGAL,
};

fn isNumber(ch: u8) bool {
    return std.ascii.isDigit(ch);
}

fn isCharcter(ch: u8) bool {
    return std.ascii.isAlphabetic(ch) or ch == '_';
}

pub const Lexer = struct {
    const Self = @This();

    ch: u8 = 0,
    position: usize = 0,
    readPosition: usize = 0,
    input: []const u8,

    fn init(input: []const u8) Lexer {
    pub fn init(input: []const u8) Lexer {
        var lex = Self{ .input = input };
        lex.nextChar();
        return lex;
    }

    fn nextChar(self: *Self) void {
        if (self.atEnd()) {
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
