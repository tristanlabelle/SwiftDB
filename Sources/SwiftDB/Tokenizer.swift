func tokenize(_ str: String) -> [Token] {
    var stream = CharStream(str)
    var result: [Token] = []
    while let token = nextToken(&stream) {
        result.append(token)
    }
    return result
}

func nextToken(_ stream: inout CharStream) -> Token? {
    stream.skipWhile { $0.isWhitespace }

    guard let c = stream.current else {
        return nil
    }

    if let token = singleCharTokens[c] {
        stream.consume()
        return token
    }

    if c == "'" {
        stream.consume()
        let str = stream.consumeWhile { $0 != "\'" }
        stream.consume()
        return .singleQuotedString(str)
    }

    if c.isLetter {
        let identifier = stream.consumeWhile { $0.isLetter }
        if let keyword = Keyword(rawValue: identifier.lowercased()) {
            return .keyword(keyword)
        }
        else {
            return .identifier(identifier)
        }
    }

    if isDigit(c) {
        let digits = stream.consumeWhile { isDigit($0) }
        let value = Int64(digits)!
        return .integer(value)
    }

    return nil
}

fileprivate let singleCharTokens: [Character: Token] = [
    ",": .comma,
    "*": .star,
    ";": .semicolon,
    "(": .openParen,
    ")": .closeParen
]

fileprivate func isDigit(_ c: Character) -> Bool {
    return c >= "0" && c <= "9"
}