public func runRepl() {
    let database = MemoryDatabase()

    while true {
        print("SwiftDB> ", terminator: "")
        guard let line = readLine() else { break }
        if line.lowercased() == "exit" { break }

        do {
            let statement = try parseStatement(str: line)
            try database.execute(statement)
        }
        catch let error as ParseError {
            print(error)
        }
        catch let error {
            print(error)
        }
    }
}