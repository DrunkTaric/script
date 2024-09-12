const std = @import("std");
const Token = @import("../lexer/types.zig").Token;

const Expression = struct { type: ExpressionTypes, name: *?type, value: *?type };
const ExpressionTypes = enum { LetExpression, BlockExpresion, AssignExpression, CallExpression, IfExporession, ElseExpression };
const LetExpressionError = error{ IdentifierNotFound, AssignedNorEnd };

fn ExpressionMaker() type {
    return struct {
        const This = @This();

        types: std.ArrayList(Expression),
        tokens: std.ArrayList(),

        fn parseLetExpression() !void {
            // we're at the LET now
            This.nextToken(); // we're at the Identifier now
            if (This.currentToken != Token.IDENTIFIER) return LetExpressionError.IdentifierNotFound;
            var iden = This.currentToken.IDENTIFIER;
            This.nextToken(); // we're at the = or ;
            if (This.currentToken != Token.ASSIGN and This.currentToken != Token.SEMICOLON) return LetExpressionError.AssignedNorEnd;
            if (This.currentToken == Token.SEMICOLON) {
                const returned_expression = Expression{ .type = .LetExpression, .value = undefined };
                return returned_expression;
            }
            This.nextToken(); // getting the next expression
            var expression = This.parseToken();
            const returned_expression = Expression{ .type = .AssignExpression, .name = &iden, .value = &expression };
            return returned_expression;
        }

        pub fn parseExpression(token: Token) Expression {
            const tok = switch (token) {
                Token.LET => parseLetExpression() catch |e| switch (e) {
                    LetExpressionError.AssignedNorEnd => @panic("[ Error ] didn't find `;` to close the satement, or `=` to assign the identifer to a statement"),
                    LetExpressionError.IdentifierNotFound => @panic("[ Error ] identifier name not found"),
                    else => @panic("[ Error ] while parsing!"),
                },
            };
            return tok;
        }
    };
}
