enum QueryError: Hashable, Error {
    case tableAlreadyExists(String)
    case noSuchTable(String)
    case noSuchColumn(String)
    case invalidValueCount
}