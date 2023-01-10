

// func nextToken(substring: Substring) -> Optional<Token> {
//     if substring.isEmpty {
//         return nil
//     }

//     var length = 0;
// }

fileprivate func isLetter(_ c : Character) -> Bool {
    return (c >= "a" && c <= "z") || (c >= "A" && c <= "Z");
}