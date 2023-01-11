// A token iterator which supports peeking
struct TokenStream {
    private(set) var current: Token?
    private var rest: any IteratorProtocol<Token>

    init(_ tokens: some Sequence<Token>) {
        self.rest = tokens.makeIterator()
        self.current = rest.next()
    }

    func currentOrThrow() throws -> Token {
        if let current {
            return current
        }
        throw ParseError.unexpectedEndOfFile
    }

    mutating func tryConsume(_ expected: Token) -> Bool {
        if current != expected {
            return false
        }
        current = rest.next()
        return true
    }

    mutating func consume(_ token: Token) throws {
        if token != current {
            throw ParseError.unexpectedToken
        }
        current = rest.next()
    }

    mutating func consume() throws -> Token {
        let result = try currentOrThrow()
        current = rest.next()
        return result
    }

    mutating func consumeIdentifier() throws -> String {
        switch current {
            case .identifier(let s):
                current = rest.next()
                return s
            default: throw ParseError.unexpectedToken
        }
    }
}