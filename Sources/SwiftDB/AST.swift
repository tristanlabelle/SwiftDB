enum Statement: Hashable {
    case select(columns: ColumnList, table: String)
}

enum ColumnList: Hashable {
    case all
    case some([String])
}