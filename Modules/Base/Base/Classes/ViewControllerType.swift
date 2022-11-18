//
//  ViewControllerType.swift
//  Base
//
//  Created by Daniel Le on 18/11/2022.
//

import Foundation

public protocol ViewControllerType: AnyObject {
    associatedtype ViewModelType
    
    func configViewModel(viewModel: ViewModelType)
    func setupViews()
    func bindViewModel()
}
