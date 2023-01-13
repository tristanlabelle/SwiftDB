class MemoryDatabase {
    private var tables: [String: MemoryTable] = [:]

    func execute(_ statement: Statement) throws {
        switch statement {
            case .create(let table, let ifNotExists, let columns):
                try create(table: table, ifNotExists: ifNotExists, columns: columns)
            case .drop(let table):
                drop(table: table)
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
            fatalError() // TODO: Actual error type
        }

        tables[nameKey] = MemoryTable(name: nameKey, columns: columns)
    }

    func drop(table: String) {
        tables.removeValue(forKey: table.lowercased())
    }
}

class MemoryTable {
    private(set) var name: String
    private(set) var columns: [ColumnDefinition]
    private var rows: [[String]] = []

    init(name: String, columns: [ColumnDefinition]) {
        self.name = name
        self.columns = columns
    }
}