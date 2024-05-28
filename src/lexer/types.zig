pub const Token = union(enum) {
    // Types
    NUMBER: []const u8,
    STRING: []const u8,
    BOOLEAN: bool,
    // Keywords
    LET,
    IDENTIFIER: []const u8,
    FUNCTION,
    RETURN,
    IF,
    ELSE,
    // Operators
    EQUAL,
    ASSIGN,
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
    COMMENT: []const u8,
    EOF,
    ILLEGAL,
};
