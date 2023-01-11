fileprivate let singleCharTokens: [Character: Token] = [
    ",": .comma,
    "*": .star,
    ";": .semicolon,
    "(": .openParen,
    ")": .closeParen
]

func nextToken(_ stream: inout CharStream) -> Token? {
    stream.skipWhile { $0.isWhitespace }

    guard let c = stream.current else {
        return nil
    }

    if let token = singleCharTokens[c] {
        stream.consume()
        return token
    }

    if c.isLetter {
        let identifier = stream.consumeWhile { $0.isLetter }!
        if let keyword = Keyword(rawValue: identifier.lowercased()) {
            return .keyword(keyword)
        }
        else {
            return .identifier(identifier)
        }
    }

    return nil
}

func tokenize(_ str: String) -> [Token] {
    var stream = CharStream(str)
    var result: [Token] = []
    while let token = nextToken(&stream) {
        result.append(token)
    }
    return result
}