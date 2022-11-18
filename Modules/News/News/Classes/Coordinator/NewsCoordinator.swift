//
//  NewsCoordinator.swift
//  News
//
//  Created by Daniel Le on 18/11/2022.
//

import Base
import RxSwift

public class NewsCoordinator: Coordinator {
    public var parentCoordinator: Coordinator?
    public var childrenCoordinator: [Coordinator] = []
    public var navigationController: UINavigationController
    private let disposeBag = DisposeBag()
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let newsViewController = NewsViewController(nibName: "NewsViewController", bundle: Bundle(for: NewsViewController.self))
        let newsViewModel = NewsViewModel()
        newsViewModel
            .output
            .onNext
            .subscribe(onNext: { [weak self] article in
                self?.navigateToNewsDetail(with: article)
            })
            .disposed(by: disposeBag)
        
        newsViewController.configViewModel(viewModel: newsViewModel)
        self.navigationController.viewControllers = [newsViewController]
    }
    
    private func navigateToNewsDetail(with article: Article) {
        let newsDetailViewController = NewsDetailViewController(nibName: "NewsDetailViewController", bundle: Bundle(for: NewsDetailViewController.self))
        newsDetailViewController.article = article
        self.navigationController.pushViewController(newsDetailViewController, animated: true)
    }
}
