class MemoryDatabase {
    private var tables: [String: MemoryTable] = [:]

    func execute(_ statement: Statement) throws -> MemoryTable? {
        switch statement {
            case .create(let table, let ifNotExists, let columns):
                try create(table: table, ifNotExists: ifNotExists, columns: columns)
                return nil
            case .drop(let table):
                try drop(table: table)
                return nil
            case .insert(let table, let columns, let values):
                try insert(into: table, columns: columns, values: values)
                return nil
            case .select(let columns, let table):
                return try select(columns: columns, from: table)
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

    func drop(table: String) throws {
        if tables.removeValue(forKey: table.lowercased()) == nil {
            throw QueryError.noSuchTable(table)
        }
    }

    func insert(into: String, columns: [String]?, values: [Expression]) throws {
        guard let table = tables[into.lowercased()] else {
            throw QueryError.noSuchTable(into)
        }
        
        if columns != nil {
            fatalError("Not implemented")
        }
        
        let row = try values.map { try evaluate(expr: $0) }
        try table.addRow(row: row)
    }

    func select(columns: [String]?, from: String) throws -> MemoryTable {
        guard let table = tables[from.lowercased()] else {
            throw QueryError.noSuchTable(from)
        }

        if columns == nil {
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

class MemoryTable {
    private(set) var name: String?
    private(set) var columns: [ColumnDefinition]
    private(set) var rows: [[String]] = []

    init(name: String?, columns: [ColumnDefinition]) {
        self.name = name
        self.columns = columns
    }

    func addRow(row: [String]) throws {
        if row.count != columns.count {
            throw QueryError.invalidValueCount
        }

        rows.append(row)
    }

    func clone(withName: String?) -> MemoryTable {
        let clone = MemoryTable(name: withName, columns: columns)
        clone.rows = rows
        return clone
    }
}