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
            .select(columns: .all, table: "mytable"))

        XCTAssertEqual(
            try SwiftDB.parseStatement(tokens: [
                .keyword(.select),
                .identifier("mycolumn"),
                .keyword(.from),
                .identifier("mytable")
                ]),
            .select(columns: .some(["mycolumn"]), table: "mytable"))

        XCTAssertEqual(
            try SwiftDB.parseStatement(tokens: [
                .keyword(.select),
                .identifier("column1"),
                .comma,
                .identifier("column2"),
                .keyword(.from),
                .identifier("mytable")
                ]),
            .select(columns: .some(["column1", "column2"]), table: "mytable"))
    }
}
