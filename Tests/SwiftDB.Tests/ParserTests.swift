import XCTest
@testable import SwiftDB

final class ParserTests: XCTestCase {
    func testSelect() throws {
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

    func testCreateTable() throws {
        XCTAssertEqual(
            try SwiftDB.parseStatement(tokens: [
                .keyword(.create), .keyword(.table), .identifier("items"), .openParen,
                    .identifier("id"), .identifier("int"), .keyword(.primary), .keyword(.key), .comma,
                    .identifier("name"), .identifier("varchar"),
                .closeParen
                ]),
            .create(table: "items", ifNotExists: false, columns: [
                ColumnDefinition(name: "id", type: .int, primaryKey: true),
                ColumnDefinition(name: "name", type: .varchar(nil), primaryKey: false),
            ]))
    }

    func testDelete() throws {
        XCTAssertEqual(
            try SwiftDB.parseStatement(tokens: [ .keyword(.delete), .keyword(.from), .identifier("mytable") ]),
            .delete(from: "mytable"))
    }

    func testDropTable() throws {
        XCTAssertEqual(
            try SwiftDB.parseStatement(tokens: [ .keyword(.drop), .keyword(.table), .identifier("mytable") ]),
            .drop(table: "mytable"))
    }

    func testInsertInto() throws {
        XCTAssertEqual(
            try SwiftDB.parseStatement(tokens: [
                .keyword(.insert), .keyword(.into), .identifier("mytable"),
                .openParen, .identifier("mycolumn"), .closeParen,
                .keyword(.values), .openParen, .singleQuotedString("myvalue"), .closeParen ]),
            .insert(into: "mytable", columns: ["mycolumn"], values: [Expression.stringLiteral("myvalue")]))
    }
}
