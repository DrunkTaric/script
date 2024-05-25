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

    pub fn init(input: []const u8) Lexer {
        var lex = Self{ .input = input };
        lex.nextChar();
        return lex;
    }

    fn atEnd(self: *Self) bool {
        // std.debug.print("input length: {?}\n", .{self.input.len});
        // std.debug.print("current position: {?}\n", .{self.position});
        // std.debug.print("next position: {?}\n", .{self.readPosition});
        // std.debug.print("are we at the end ? {?}\n", .{self.readPosition >= self.input.len});
        // std.debug.print("=========================\n", .{});
        return self.readPosition >= self.input.len;
    }

    fn peakChar(self: *Self) u8 {
        return self.input[self.readPosition];
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

    fn readString(self: *Self) []const u8 {
        const start = self.position;
        self.nextChar();
        while (!self.atEnd() and self.ch != '"') {
            self.nextChar();
        }
        return self.input[start + 1 .. self.position];
    }

    fn readInt(self: *Self) []const u8 {
        const start = self.position;
        while (!self.atEnd() and isNumber(self.ch)) {
            self.nextChar();
        }
        return self.input[start..self.position];
    }

    fn readChar(self: *Self) []const u8 {
        const start = self.position;
        while (!self.atEnd() and isCharcter(self.ch)) {
            self.nextChar();
        }
        return self.input[start..self.position];
    }

    pub fn nextToken(self: *Self) Token {
        // std.debug.print("current caracter: {?}", .{self.ch});
        const token: Token = switch (self.ch) {
            0 => .EOF,

            '0'...'9' => turn: {
                break :turn .{ .NUMBER = self.readInt() };
            },
            'A'...'Z', 'a'...'z', '_' => turn: {
                break :turn .IDENTIFIER;
            },

            '/' => .DEVIDE,
            '*' => .MULTIPLY,
            '=' => .EQUAL,
            '+' => .PLUS,
            '-' => .MINUS,

            '>' => .GREATERTHAN,
            '<' => .LESSTHAN,

            ',' => .COMMA,
            ';' => .SEMICOLON,
            '(' => .LPAREN,
            ')' => .RPAREN,
            '{' => .LBRACE,
            '}' => .RBRACE,

            '"' => turn: {
                break :turn .{ .STRING = self.readString() };
            },

            else => .ILLEGAL,
        };

        self.nextChar();

        return token;
    }
};

const expectEqualDeep = std.testing.expectEqualDeep;

test "test getnextToken()" {
    const input = "=+(){},;";
    var lex = Lexer.init(input);
    const tokens = [_]Token{ .EQUAL, .PLUS, .LPAREN, .RPAREN, .LBRACE, .RBRACE, .COMMA, .SEMICOLON };
    for (tokens) |token| {
        const tok = lex.nextToken();
        try expectEqualDeep(token, tok);
    }
}
