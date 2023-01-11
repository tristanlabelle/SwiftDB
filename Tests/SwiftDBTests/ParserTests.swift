import XCTest
@testable import SwiftDB

final class ParserTests: XCTestCase {
    func testBasicSelect() throws {
        XCTAssertEqual(
            try SwiftDB.parseStatement(tokens: [
                .keyword(.select),
                .star,
                .keyword(.from),
                .identifier("mytable")
                ]),
            .select(columns: nil, from: "mytable"))

        XCTAssertEqual(
            try SwiftDB.parseStatement(tokens: [
                .keyword(.select),
                .identifier("mycolumn"),
                .keyword(.from),
                .identifier("mytable")
                ]),
            .select(columns: ["mycolumn"], from: "mytable"))

        XCTAssertEqual(
            try SwiftDB.parseStatement(tokens: [
                .keyword(.select),
                .identifier("column1"),
                .comma,
                .identifier("column2"),
                .keyword(.from),
                .identifier("mytable")
                ]),
            .select(columns: ["column1", "column2"], from: "mytable"))
    }
}
