enum Statement: Hashable {
    case create(table: String, ifNotExists: Bool = false, columns: [ColumnDefinition])
    case delete(from: String, where: Expression? = nil)
    case drop(table: String)
    case insert(into: String, columns: [String]? = nil, values: [Expression])
    case update(_: String, set: [ColumnAssignment], where: Expression? = nil)
    case select(columns: [String]? = nil, from: String, where: Expression? = nil)
}

struct ColumnDefinition: Hashable {
    var name: String
    var type: ColumnType
    var primaryKey: Bool = false
}

struct ColumnAssignment: Hashable {
    var name: String
    var value: Expression
}

enum ColumnType: Hashable {
    case bool
    case char(_ size: Int)
    case int
    case varchar(_ size: Int?)
}

enum Expression: Hashable {
    case stringLiteral(_ value: String)
    case integerLiteral(_ value: Int64)
}