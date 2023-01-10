enum Token: Hashable {
    case keyword(Keyword)
    case identifier(String)
    case comma
    case semicolon
    case star
}

enum Keyword: Hashable {
    case create
    case from
    case insert
    case `is`
    case select
    case update
    case `where`
}