//
//  Coordinator.swift
//  Base
//
//  Created by Daniel Le on 18/11/2022.
//

public protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childrenCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
