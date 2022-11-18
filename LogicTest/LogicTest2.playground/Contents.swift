
// Complexity: O(n)
func checkPalindrome(string: String) -> Bool {
    var stringLength = 0
    var stringArray: [String] = []
    for character in string {
        stringArray.append(String(character).lowercased())
        stringLength += 1
    }
    
    if stringLength < 2 {
        return true
    }
    
    for index in 0..<(stringLength / 2) {
        if stringArray[index] != stringArray[stringLength - 1 - index] {
            return false
        }
    }
    return true
}

func getResult(string: String) -> String {
    return checkPalindrome(string: string) ? "\(string) is a palindrome" : "\(string) isn’t a palindrome"
}

["", "a", "aA", "aKa", "akA", "akkA", "Helleh", "Helhe"].forEach {
    print(getResult(string: $0))
}
