//
//  ViewModelType.swift
//  Base
//
//  Created by Daniel Le on 18/11/2022.
//

import Foundation

public protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get set }
    var output: Output { get set }
}
