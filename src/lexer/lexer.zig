const std = @import("std");
const checker = @import("../utils/checker.zig");
const isNumber = checker.isNumber;
const isCharcter = checker.isCharcter;
const Token = @import("./types.zig").Token;

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
        if (self.atEnd()) {
            return 0;
        }
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
        while (self.peakChar() != '"') {
            self.nextChar();
        }
        return self.input[start..self.position];
    }

    fn readInt(self: *Self) []const u8 {
        const start = self.position;
        while (isNumber(self.peakChar())) {
            self.nextChar();
        }
        return self.input[start .. self.position + 1];
    }

    fn readChar(self: *Self) []const u8 {
        const start = self.position;
        while (isCharcter(self.peakChar())) {
            self.nextChar();
        }
        return self.input[start .. self.position + 1];
    }

    fn readComment(self: *Self) []const u8 {
        const start = self.position;
        while (!(self.ch == '/' and self.peakChar() == '/')) {
            self.nextChar();
        }
        return self.input[start..self.position];
    }

    fn skipWhitespace(self: *Self) void {
        while (std.ascii.isWhitespace(self.ch)) {
            self.nextChar();
        }
    }

    pub fn nextToken(self: *Self) Token {
        // std.debug.print("current caracter: {?}", .{self.ch});
        self.skipWhitespace();
        // std.debug.print("Current index that being tokenize is: {?}\n", .{self.position});
        // std.debug.print("Current chacter that being tokenize is: {c}\n", .{self.ch});
        const token: Token = switch (self.ch) {
            0 => .EOF,

            '0'...'9' => turn: {
                break :turn .{ .NUMBER = self.readInt() };
            },
            'A'...'Z', 'a'...'z', '_' => turn: {
                const extracted_string: []const u8 = self.readChar();
                const map = std.ComptimeStringMap(Token, .{
                    .{ "let", .LET },
                    .{ "method", .FUNCTION },
                    .{ "true", .{ .BOOLEAN = true } },
                    .{ "false", .{ .BOOLEAN = false } },
                    .{ "when", .IF },
                    .{ "otherwise", .ELSE },
                    .{ "export", .RETURN },
                });

                if (map.get(extracted_string)) |token| {
                    break :turn token;
                }

                break :turn .{ .IDENTIFIER = extracted_string };
            },

            '/' => turn: {
                if (self.peakChar() == '/') {
                    const comment = self.readComment();
                    break :turn .{ .COMMENT = comment };
                }
                break :turn .DEVIDE;
            },
            '*' => .MULTIPLY,
            '=' => turn: {
                if (self.peakChar() == '=') {
                    self.nextChar();
                    break :turn .EQUAL;
                }
                break :turn .ASSIGN;
            },
            '!' => turn: {
                if (self.peakChar() == '=') {
                    break :turn .NOTEQUAL;
                }
                break :turn .BANG;
            },
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
