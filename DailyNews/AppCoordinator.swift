//
//  AppCoordinator.swift
//  DailyNews
//
//  Created by Daniel Le on 18/11/2022.
//

import Base
import News

public class AppCoordinator: Coordinator {
    public var parentCoordinator: Coordinator?
    public var childrenCoordinator: [Coordinator] = []
    public var navigationController: UINavigationController
    private var newsCoordinator: NewsCoordinator?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        newsCoordinator = NewsCoordinator(navigationController: navigationController)
        newsCoordinator?.start()
    }
}
