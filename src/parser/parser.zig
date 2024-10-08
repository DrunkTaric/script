const std = @import("std");
const Lexer = @import("./lexer/lexer.zig").Lexer;
const Token = @import("./lexer/types.zig").Token;

const Expression = struct { literal: *[]const u8, value: ?*const Expression };

const LetError = error{ IdentifierNotFound, AssignNorEnd, ValueNotFound };
const LetExpression = struct { name: *[]const u8, value: ?*type };

const ConditionError = error{};
const ConditionTypes = enum { Equal, lowerThan, greaterThan, lowerOrEqual, greaterOrEqual, notEqual };
const ConditionExpression = struct { leftSide: *Expression, rightSide: *Expression, type: ConditionError, literal: []const u8 };

const ValueError = error{};
const NumberExpression = struct { value: *[]const u8 };
const StringExpression = struct { value: *[]const u8 };
const BooleanExpression = struct { value: *bool };

fn ParseResult2(comptime expression: type) !type {
    return struct {
        const This = @This();

        type: expression,

        pub fn init(value: expression) This {
            return This{ .type = value };
        }
    };
}

pub const Parser = struct {
    program_array: std.ArrayList,
    currentToken: Token,
    peekToken: Token,
    lexer: *Lexer,

    pub fn init(lex: *Lexer) Parser {
        var p = Parser{
            .lexer = lex,
            .peekToken = Token.ILLEGAL,
            .currentToken = Token.ILLEGAL,
        };
        // setting the peek an the current token
        p.nextToken();
        p.nextToken();

        var gpa = std.heap.GeneralPurposeAllocator(.{}, {});
        const allocator = gpa.allocator();
        p.program_array = std.ArrayList(type).init(allocator);

        return p;
    }

    fn nextToken(self: *Parser) void {
        self.currentToken = self.peekToken;
        self.peekToken = self.lexer.nextToken();
    }

    fn parseNumber(_: *Parser, number: *[]const u8) NumberExpression {
        return NumberExpression{ .value = number };
    }

    fn parseString(_: *Parser, string: *[]const u8) StringExpression {
        return StringExpression{ .value = string };
    }

    fn parseBoolean(_: *Parser, boolean: *bool) BooleanExpression {
        return BooleanExpression{ .value = boolean };
    }

    pub fn parseToken(_: *Parser) Expression {
        const exp = Expression{ .literal = undefined, .value = undefined };
        return exp;
    }

    pub fn parseToken1(self: *Parser) type {
        const emptyExpression = Expression{ .literal = undefined, .value = undefined };
        const tok = switch (self.currentToken) {
            Token.LET => ParseResult2(.LetExpression).init(self.parseIdentifier()) catch |e| switch (e) {
                LetError.AssignNorEnd => @panic("[ Error ] didn't find `;` to close the satement, or `=` to assign the identifer to a statement"),
                LetError.IdentifierNotFound => @panic("[ Error ] identifier name not found"),
                else => @panic("[ Error ] while parsing!"),
            },
            Token.NUMBER => turn: {
                if (self.peekToken == .SEMICOLON) {
                    var number = self.currentToken.NUMBER;
                    const expression = self.parseNumber(&number);
                    self.nextToken();
                    break :turn ParseResult2(.NumberExpression).init(expression);
                }
                if (self.peekToken == .EQUAL or self.peekToken == .GREATERTHAN or self.peekToken == .LESSTHAN or self.peekToken == .NOTEQUAL) {
                    break :turn ParseResult2(.Expression).init(emptyExpression);
                }
                break :turn ParseResult2(.Expression).init(emptyExpression);
            },
            else => ParseResult2(.Expression).init(emptyExpression),
        };
        self.nextToken();
        return tok;
    }

    fn parseIdentifier(self: *Parser) LetError!LetExpression {
        // we're at the LET now
        self.nextToken(); // we're at the Identifier now
        if (self.currentToken != Token.IDENTIFIER) return LetError.IdentifierNotFound;
        var iden = self.currentToken.IDENTIFIER;
        self.nextToken(); // we're at the = or ;
        if (self.currentToken != Token.ASSIGN and self.currentToken != Token.SEMICOLON) return LetError.AssignNorEnd;
        if (self.currentToken == Token.SEMICOLON) {
            const returned_expression = LetExpression{ .name = &iden, .value = undefined };
            return returned_expression;
        }
        self.nextToken(); // getting the next expression
        var expression = self.parseToken();
        const returned_expression = LetExpression{ .name = &iden, .value = &expression };
        return returned_expression;
    }
};
