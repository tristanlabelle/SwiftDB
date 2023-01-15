import XCTest
@testable import SwiftDB

final class MemoryDatabaseTests: XCTestCase {
    func testCreateDeleteTable() throws {
        let db = SwiftDB.MemoryDatabase()
        XCTAssertNil(try db.create(table: "foo", ifNotExists: false, columns: [
            ColumnDefinition(name: "id", type: .int)]))
        XCTAssertNil(try db.drop(table: "foo"))
    }
}
