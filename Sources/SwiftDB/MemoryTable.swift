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

    func deleteRows(where predicate: ([String]) throws -> Bool) throws {
        try rows.removeAll(where: predicate)
    }

    func clone(withName: String?) -> MemoryTable {
        let clone = MemoryTable(name: withName, columns: columns)
        clone.rows = rows
        return clone
    }
}