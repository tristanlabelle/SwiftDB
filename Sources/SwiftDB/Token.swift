enum Token: Hashable {
    case closeParen
    case comma
    case keyword(Keyword)
    case identifier(String)
    case integer(Int64)
    case openParen
    case singleQuotedString(String)
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
    case drop
    case exists
    case group
    case from
    case insert
    case into
    case `if`
    case `is`
    case key
    case like
    case not
    case null
    case or
    case order
    case primary
    case select
    case set
    case table
    case update
    case values
    case `where`
}