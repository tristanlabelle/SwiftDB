import XCTest
@testable import SwiftDB

final class TokenizerTests: XCTestCase {
    func testIdentifiersAndKeywords() throws {
        XCTAssertEqual(
            SwiftDB.tokenize("hello"),
            [ Token.identifier("hello") ])

        XCTAssertEqual(
            SwiftDB.tokenize("select"),
            [ Token.keyword(.select) ])
    }

    func testKeywordCaseInsensitivity() throws {
        XCTAssertEqual(
            SwiftDB.tokenize("selECT"),
            [ Token.keyword(.select) ])
    }
    
    func testWhitespace() throws {
        XCTAssertEqual(
            SwiftDB.tokenize("  hello \n world  "),
            [ Token.identifier("hello"), Token.identifier("world") ])
    }

    func testSelectStar() throws {
        XCTAssertEqual(
            SwiftDB.tokenize("select * from mytable"),
            [ Token.keyword(.select), Token.star, Token.keyword(.from), Token.identifier("mytable") ])
    }
}
