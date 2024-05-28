const std = @import("std");

pub fn isNumber(ch: u8) bool {
    return std.ascii.isDigit(ch);
}

pub fn isCharcter(ch: u8) bool {
    return std.ascii.isAlphabetic(ch) or ch == '_';
}
