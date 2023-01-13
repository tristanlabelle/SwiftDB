// A token iterator which supports peeking
struct TokenStream {
    private(set) var current: Token?
    private var rest: any IteratorProtocol<Token>

    var currentOrThrow: Token {
        get throws {
            if let current { return current }
            throw ParseError.unexpectedEndOfFile
        }
    }

    init(_ tokens: some Sequence<Token>) {
        self.rest = tokens.makeIterator()
        self.current = rest.next()
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

    @discardableResult mutating func consume() -> Token {
        let result = current!
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