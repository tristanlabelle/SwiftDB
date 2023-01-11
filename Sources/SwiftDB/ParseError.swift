enum ParseError: Error {
    case unexpectedEndOfFile
    case unexpectedToken
    case unknownType
}