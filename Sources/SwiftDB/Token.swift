enum Token: Hashable {
    case keyword(Keyword)
    case identifier(String)
    case comma
    case semicolon
    case star
}

enum Keyword: String, Hashable, CaseIterable {
    case alter
    case and
    case `as`
    case by
    case column
    case create
    case database
    case delete
    case exists
    case group
    case from
    case insert
    case `if`
    case `is`
    case like
    case not
    case null
    case or
    case order
    case select
    case set
    case table
    case update
    case values
    case `where`
}