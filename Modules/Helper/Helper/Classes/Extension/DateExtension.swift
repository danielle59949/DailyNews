//
//  DateExtension.swift
//  Helper
//
//  Created by Daniel Le on 18/11/2022.
//

import Foundation

public extension Date {
    func string(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
