class MemoryDatabase {
    private var tables: [String: MemoryTable] = [:]

    func execute(_ statement: Statement) throws -> MemoryTable? {
        switch statement {
            case .create(let table, let ifNotExists, let columns):
                try create(table: table, ifNotExists: ifNotExists, columns: columns)
                return nil
            case .delete(let table, let condition):
                try delete(from: table, where: condition)
                return nil
            case .drop(let table):
                try drop(table: table)
                return nil
            case .insert(let table, let columns, let values):
                try insert(into: table, columns: columns, values: values)
                return nil
            case .select(let columns, let table, let condition):
                return try select(columns: columns, from: table, where: condition)
            default:
                fatalError("Not implemented")
        }
    }

    func create(table: String, ifNotExists: Bool, columns: [ColumnDefinition]) throws {
        let nameKey = table.lowercased()
        if tables[nameKey] != nil {
            if ifNotExists {
                return
            }
            throw QueryError.tableAlreadyExists(table)
        }

        tables[nameKey] = MemoryTable(name: nameKey, columns: columns)
    }

    func delete(from tableName: String, where condition: Expression? = nil) throws {
        guard let table = tables[tableName.lowercased()] else {
            throw QueryError.noSuchTable(tableName)
        }

        if condition == nil {
            return try table.deleteRows(where: { _ in true })
        }
        else {
            fatalError("Not implemented")
        }
    }

    func drop(table: String) throws {
        if tables.removeValue(forKey: table.lowercased()) == nil {
            throw QueryError.noSuchTable(table)
        }
    }

    func insert(into tableName: String, columns: [String]? = nil, values: [Expression]) throws {
        guard let table = tables[tableName.lowercased()] else {
            throw QueryError.noSuchTable(tableName)
        }
        
        if columns != nil {
            fatalError("Not implemented")
        }
        
        let row = try values.map { try evaluate(expr: $0) }
        try table.addRow(row: row)
    }

    func select(columns: [String]? = nil, from tableName: String, where condition: Expression? = nil) throws -> MemoryTable {
        guard let table = tables[tableName.lowercased()] else {
            throw QueryError.noSuchTable(tableName)
        }

        if columns == nil && condition == nil {
            return table.clone(withName: nil)
        }
        else {
            fatalError("Not implemented")
        }
    }

    func evaluate(expr: Expression) throws -> String {
        switch expr {
            case .stringLiteral(let str): return str
            case .integerLiteral(let value): return value.description
            default: fatalError("Not implemented")
        }
    }
}
