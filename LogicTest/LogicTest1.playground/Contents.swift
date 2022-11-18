
// complexity: O(n)
func searchMiddleIndex(in array: [Int]) -> Int? {
    /// if array have 1 element =>  middle Index is 0
    if array.count == 1 {
        return 0
    }
    /// if array has less than 3 element => no middle index
    if array.count <= 2 {
        return nil
    }
    /// array of sum left, start with 0
    var sumLeftArray: [Int] = [0]
    var totalValue: Int = 0
    for (index, element) in array.enumerated() {
        let nextValue = element + sumLeftArray[index]
        if index + 1 == array.count {
            totalValue = nextValue
        } else {
            sumLeftArray.append(nextValue)
        }
    }
    for (index, sumLeftElement) in sumLeftArray.enumerated() {
        if totalValue - array[index] == sumLeftElement * 2 {
            return index
        }
    }
    return nil
}

func getResult(in array: [Int]) -> String {
    if let index = searchMiddleIndex(in: array) {
        return "middle index is \(index)"
    }
    return "index not found"
}

[
    [],
    [5],
    [1, 3],
    [2, 2, 2],
    [3, 5, 6],
    [2, 0, 0, 2],
    [1, 3, 5, 7, 9],
    [1, -3, -5, 7, -7],
    [4, 7, 8, 1, 5, 10, 2, 8]
].forEach {
    print(getResult(in: $0))
}
