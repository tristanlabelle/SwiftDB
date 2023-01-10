func parseStatement(tokens: some Sequence<Token>) throws -> Statement {
    var parser = Parser(TokenStream(tokens))
    return try parser.parseStatement()
}

fileprivate struct Parser {
    var tokens: TokenStream

    init(_ tokens: TokenStream) {
        self.tokens = tokens
    }

    mutating func parseStatement() throws -> Statement {
        switch tokens.current {
            case .keyword(.select): return try parseSelectStatement()
            default: throw ParseError.unexpectedToken
        }
    }

    private mutating func parseSelectStatement() throws -> Statement {
        try tokens.consume(.keyword(.select))
        let columns = try parseColumnList()
        try tokens.consume(.keyword(.from))
        let tableName = try tokens.consumeIdentifier()
        return .select(columns: columns, table: tableName)
    }

    private mutating func parseColumnList() throws -> ColumnList {
        if tokens.tryConsume(.star) {
            return .all
        }
        
        var columnNames = [ try tokens.consumeIdentifier() ]
        while tokens.tryConsume(.comma) {
            columnNames.append(try tokens.consumeIdentifier())
        }
        return .some(columnNames)
    }
}
