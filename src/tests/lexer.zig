const std = @import("std");
const Lexer = @import("../lexer/lexer.zig").Lexer;
const Token = @import("../lexer/types.zig").Token;
const expectEqualDeep = std.testing.expectEqualDeep;

test "test getnextToken()" {
    const input = "=+(){},;";
    var lex = Lexer.init(input);
    const tokens = [_]Token{ .ASSIGN, .PLUS, .LPAREN, .RPAREN, .LBRACE, .RBRACE, .COMMA, .SEMICOLON };
    for (tokens) |token| {
        const tok = lex.nextToken();
        //std.debug.print("Current Token From lexer is: {?}\n", .{tok});
        //std.debug.print("Current Token From array is: {?}\n", .{token});
        //std.debug.print("=======================\n", .{});
        try expectEqualDeep(token, tok);
    }
}

test "test 2nd phase in lexer" {
    const input =
        \\let five = 5;
        \\let ten = 10;
        \\let add = method(x, y) {
        \\x + y;
        \\};
        \\let result = add(five, ten);
    ;
    var lex = Lexer.init(input);
    const tokens = [_]Token{
        .LET,
        .{ .IDENTIFIER = "five" },
        .ASSIGN,
        .{ .NUMBER = &.{53} },
        .SEMICOLON,
        .LET,
        .{ .IDENTIFIER = "ten" },
        .ASSIGN,
        .{ .NUMBER = &.{ 49, 48 } },
        .SEMICOLON,
        .LET,
        .{ .IDENTIFIER = "add" },
        .ASSIGN,
        .FUNCTION,
        .LPAREN,
        .{ .IDENTIFIER = "x" },
        .COMMA,
        .{ .IDENTIFIER = "y" },
        .RPAREN,
        .LBRACE,
        .{ .IDENTIFIER = "x" },
        .PLUS,
        .{ .IDENTIFIER = "y" },
        .SEMICOLON,
        .RBRACE,
        .SEMICOLON,
        .LET,
        .{ .IDENTIFIER = "result" },
        .ASSIGN,
        .{ .IDENTIFIER = "add" },
        .LPAREN,
        .{ .IDENTIFIER = "five" },
        .COMMA,
        .{ .IDENTIFIER = "ten" },
        .RPAREN,
        .SEMICOLON,
        .EOF,
    };
    for (tokens) |token| {
        const tok = lex.nextToken();
        //std.debug.print("Current Token From lexer is: {?}\n", .{tok});
        //std.debug.print("Current Token From array is: {?}\n", .{token});
        //std.debug.print("=======================\n", .{});
        try expectEqualDeep(token, tok);
    }
}

test "test 3rd phase Lexer" {
    const input =
        \\let five = 5;
        \\let ten = 10;
        \\let add = method(x, y) {
        \\x + y;
        \\};
        \\let result = add(five, ten);
        \\!-/*5;
        \\5 < 10 > 5;
    ;
    var lex = Lexer.init(input);
    const tokens = [_]Token{
        .LET,
        .{ .IDENTIFIER = "five" },
        .ASSIGN,
        .{ .NUMBER = &.{53} },
        .SEMICOLON,
        .LET,
        .{ .IDENTIFIER = "ten" },
        .ASSIGN,
        .{ .NUMBER = &.{ 49, 48 } },
        .SEMICOLON,
        .LET,
        .{ .IDENTIFIER = "add" },
        .ASSIGN,
        .FUNCTION,
        .LPAREN,
        .{ .IDENTIFIER = "x" },
        .COMMA,
        .{ .IDENTIFIER = "y" },
        .RPAREN,
        .LBRACE,
        .{ .IDENTIFIER = "x" },
        .PLUS,
        .{ .IDENTIFIER = "y" },
        .SEMICOLON,
        .RBRACE,
        .SEMICOLON,
        .LET,
        .{ .IDENTIFIER = "result" },
        .ASSIGN,
        .{ .IDENTIFIER = "add" },
        .LPAREN,
        .{ .IDENTIFIER = "five" },
        .COMMA,
        .{ .IDENTIFIER = "ten" },
        .RPAREN,
        .SEMICOLON,
        .BANG,
        .MINUS,
        .DEVIDE,
        .MULTIPLY,
        .{ .NUMBER = &.{53} },
        .SEMICOLON,
        .{ .NUMBER = &.{53} },
        .LESSTHAN,
        .{ .NUMBER = &.{ 49, 48 } },
        .GREATERTHAN,
        .{ .NUMBER = &.{53} },
        .SEMICOLON,
    };
    for (tokens) |token| {
        const tok = lex.nextToken();
        //std.debug.print("Current Token From lexer is: {?}\n", .{tok});
        //std.debug.print("Current Token From array is: {?}\n", .{token});
        //std.debug.print("=======================\n", .{});
        try expectEqualDeep(token, tok);
    }
}

test "test Final phase Lexer" {
    const input =
        \\let five = 5;
        \\let ten = 10;
        \\let add = method(x, y) {
        \\x + y;
        \\};
        \\let result = add(five, ten);
        \\!-/*5;
        \\5 < 10 > 5;
        \\when (5 < 10) {
        \\export true;
        \\} otherwise {
        \\export false;
        \\}
    ;
    var lex = Lexer.init(input);
    const tokens = [_]Token{
        .LET,
        .{ .IDENTIFIER = "five" },
        .ASSIGN,
        .{ .NUMBER = &.{53} },
        .SEMICOLON,
        .LET,
        .{ .IDENTIFIER = "ten" },
        .ASSIGN,
        .{ .NUMBER = &.{ 49, 48 } },
        .SEMICOLON,
        .LET,
        .{ .IDENTIFIER = "add" },
        .ASSIGN,
        .FUNCTION,
        .LPAREN,
        .{ .IDENTIFIER = "x" },
        .COMMA,
        .{ .IDENTIFIER = "y" },
        .RPAREN,
        .LBRACE,
        .{ .IDENTIFIER = "x" },
        .PLUS,
        .{ .IDENTIFIER = "y" },
        .SEMICOLON,
        .RBRACE,
        .SEMICOLON,
        .LET,
        .{ .IDENTIFIER = "result" },
        .ASSIGN,
        .{ .IDENTIFIER = "add" },
        .LPAREN,
        .{ .IDENTIFIER = "five" },
        .COMMA,
        .{ .IDENTIFIER = "ten" },
        .RPAREN,
        .SEMICOLON,
        .BANG,
        .MINUS,
        .DEVIDE,
        .MULTIPLY,
        .{ .NUMBER = &.{53} },
        .SEMICOLON,
        .{ .NUMBER = &.{53} },
        .LESSTHAN,
        .{ .NUMBER = &.{ 49, 48 } },
        .GREATERTHAN,
        .{ .NUMBER = &.{53} },
        .SEMICOLON,
        .IF,
        .LPAREN,
        .{ .NUMBER = &.{53} },
        .LESSTHAN,
        .{ .NUMBER = &.{ 49, 48 } },
        .RPAREN,
        .LBRACE,
        .RETURN,
        .{ .BOOLEAN = true },
        .SEMICOLON,
        .RBRACE,
        .ELSE,
        .LBRACE,
        .RETURN,
        .{ .BOOLEAN = false },
        .SEMICOLON,
        .RBRACE,
    };
    for (tokens) |token| {
        const tok = lex.nextToken();
        //std.debug.print("Current Token From lexer is: {?}\n", .{tok});
        //std.debug.print("Current Token From array is: {?}\n", .{token});
        //std.debug.print("=======================\n", .{});
        try expectEqualDeep(token, tok);
    }
}
