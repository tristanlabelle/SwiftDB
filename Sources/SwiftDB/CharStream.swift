struct CharStream {
    private(set) var current: Character?
    private var rest: String.Iterator
    private(set) var column: Int

    init(_ str: String) {
        rest = str.makeIterator()
        current = rest.next()
        column = 0
    }
    
    @discardableResult mutating func skipWhile(_ predicate: (Character) -> Bool) -> Int {
        var count = 0
        while consumeIf(predicate) != nil {
            count += 1
        }
        return count
    }

    mutating func consumeIf(_ predicate: (Character) -> Bool) -> Character? {
        current != nil && predicate(current!) ? consume() : nil
    }

    mutating func consumeWhile(_ predicate: (Character) -> Bool) -> String? {
        var result = ""
        while let c = consumeIf(predicate) {
            result.append(c)
        }
        
        return result.isEmpty ? nil : result
    }
    
    @discardableResult mutating func consume() -> Character {
        let c = current!
        current = rest.next()
        // TODO: Handle newlines in column counting
        column += 1
        return c
    }
}