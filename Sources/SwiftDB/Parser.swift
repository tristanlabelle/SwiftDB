func parseStatement(str: String) throws -> Statement {
    try parseStatement(tokens: tokenize(str))
}

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
            case .keyword(.create): return try parseCreateStatement()
            case .keyword(.delete): return try parseDeleteStatement()
            case .keyword(.drop): return try parseDropStatement()
            case .keyword(.insert): return try parseInsertStatement()
            case .keyword(.select): return try parseSelectStatement()
            default: throw ParseError.unexpectedToken
        }
    }
    
    private mutating func parseCreateStatement() throws -> Statement {
        try tokens.consume(.keyword(.create))
        try tokens.consume(.keyword(.table))
        let tableName = try tokens.consumeIdentifier()

        let ifNotExists = tokens.tryConsume(.keyword(.`if`))
        if ifNotExists {
            try tokens.consume(.keyword(.not))
            try tokens.consume(.keyword(.exists))
        }

        let columns = try parseParenthesizedList { try $0.parseColumnDefinition() }

        return .create(table: tableName, ifNotExists: ifNotExists, columns: columns)
    }

    private mutating func parseDeleteStatement() throws -> Statement {
        try tokens.consume(.keyword(.delete))
        try tokens.consume(.keyword(.from))
        let tableName = try tokens.consumeIdentifier()

        let condition: Expression? = tokens.tryConsume(.keyword(.where))
            ? try parseExpression() : nil

        return .delete(from: tableName, where: condition)
    }

    private mutating func parseDropStatement() throws -> Statement {
        try tokens.consume(.keyword(.drop))
        try tokens.consume(.keyword(.table))
        let tableName = try tokens.consumeIdentifier()
        return .drop(table: tableName)
    }

    private mutating func parseColumnDefinition() throws -> ColumnDefinition {
        let name = try tokens.consumeIdentifier()
        let type = try parseColumnType()
        let primaryKey = tokens.tryConsume(.keyword(.primary))
        if primaryKey {
            try tokens.consume(.keyword(.key))
        }
        return ColumnDefinition(name: name, type: type, primaryKey: primaryKey)
    }

    private mutating func parseColumnType() throws -> ColumnType {
        let typeName = try tokens.consumeIdentifier()
        let precision: Int? = nil
        if tokens.tryConsume(.openParen) {
            fatalError("Not implemented")
        }

        switch typeName {
            case "bool": return .bool
            case "char": return .char(precision!)
            case "int", "integer": return .int
            case "varchar": return .varchar(precision)
            default: throw ParseError.unknownType
        }
    }

    private mutating func parseInsertStatement() throws -> Statement {
        try tokens.consume(.keyword(.insert))
        try tokens.consume(.keyword(.into))
        let tableName = try tokens.consumeIdentifier()

        let columnNames = tokens.current == Token.openParen
            ? try parseParenthesizedList { try $0.tokens.consumeIdentifier() }
            : nil

        try tokens.consume(.keyword(.values))
        let values = try parseParenthesizedList { try $0.parseExpression() }

        return .insert(into: tableName, columns: columnNames, values: values)
    }

    private mutating func parseParenthesizedList<T>(parseItem: (inout Parser) throws -> T) throws -> [T] {
        var items: [T] = []
        try tokens.consume(.openParen)
        while !tokens.tryConsume(.closeParen) {
            if !items.isEmpty {
                try tokens.consume(.comma)
            }
            items.append(try parseItem(&self))
        }

        return items
    }

    private mutating func parseSelectStatement() throws -> Statement {
        try tokens.consume(.keyword(.select))
        let columns = try parseColumnList()
        try tokens.consume(.keyword(.from))
        let tableName = try tokens.consumeIdentifier()
        return .select(columns: columns, from: tableName)
    }

    private mutating func parseColumnList() throws -> [String]? {
        if tokens.tryConsume(.star) {
            return nil
        }
        
        var columnNames = [ try tokens.consumeIdentifier() ]
        while tokens.tryConsume(.comma) {
            columnNames.append(try tokens.consumeIdentifier())
        }
        return columnNames
    }
    
    private mutating func parseExpression() throws -> Expression {
        switch try tokens.currentOrThrow {
            case .singleQuotedString(let str):
                tokens.consume()
                return .stringLiteral(str)

            case .integer(let value):
                tokens.consume()
                return .integerLiteral(value)

            default: fatalError("Not implemented")
        }
    }
}
