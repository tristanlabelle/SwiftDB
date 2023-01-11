enum Statement: Hashable {
    case create(table: String, ifNotExists: Bool, columns: [ColumnDefinition])
    case delete(from: String, condition: [Expression])
    case drop(table: String)
    case insert(into: String, columns: [String]?, values: [Expression])
    case update(_: String, set: [ColumnAssignment])
    case select(columns: [String]?, from: String)
}

struct ColumnDefinition: Hashable {
    var name: String
    var type: ColumnType
    var primaryKey: Bool
}

struct ColumnAssignment: Hashable {
    var name: String
    var value: Expression
}

enum ColumnType: Hashable {
    case bool
    case char(_ size: Int)
    case int
    case varchar(_ size: Int)
}

enum Expression: Hashable {
    case literalString(_ value: String)
}