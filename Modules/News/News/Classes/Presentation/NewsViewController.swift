//
//  NewsViewController.swift
//  News
//
//  Created by Daniel Le on 18/11/2022.
//

import UIKit
import BaseUI
import Base
import RxSwift
import SkeletonView

class NewsViewController: BaseViewController {
    @IBOutlet private weak var newsTableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchContainerView: UIView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerViewHeight: NSLayoutConstraint!
    
    private var viewModel: NewsViewModel!
    private let disposeBag = DisposeBag()
    private var articles = Pagination<Article>()
    private var isLoading = false
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        showLoading()
        
        isLoading = true
        viewModel.input.onSearch.onNext(nil)
    }
    
    private func showSkeleton() {
        articles.removeAll()
        newsTableView.showAnimatedGradientSkeleton()
        newsTableView.reloadData()
    }
    
    private func showEmptyView() {
        let emptyView = NewsEmptyView()
        emptyView
            .onReload
            .subscribe(onNext: { [weak self] in
                self?.refreshData()
            })
            .disposed(by: disposeBag)
        newsTableView.backgroundView = emptyView
    }
    
    private func hideEmptyView() {
        newsTableView.backgroundView = nil
    }
    
    func showLoading() {
        showSkeleton()
    }
    
    func hideLoading() {
        newsTableView.hideSkeleton()
    }
}

extension NewsViewController: ViewControllerType {
    typealias ViewModelType = NewsViewModel
    
    func configViewModel(viewModel: NewsViewModel) {
        self.viewModel = viewModel
    }
    
    func setupViews() {
        newsTableView.register(cellType: NewsTableCell.self)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.prefetchDataSource = self
        newsTableView.refreshControl = refreshControl
        newsTableView.isSkeletonable = true
        
        searchContainerView.cornerRadius = 16
    }
    
    @objc func refreshData() {
        hideEmptyView()
        showSkeleton()
        isLoading = true
        articles.removeAll()
        viewModel.input.onRefresh.onNext(())
    }
    
    func bindViewModel() {
        let input = viewModel.input
        disposeBag.insert([
            searchTextField
                .rx
                .text
                .skip(1)
                .map({ $0?.trimmingCharacters(in: .whitespacesAndNewlines) })
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] text in
                    input.onSearch.onNext(text)
                    self?.showSkeleton()
                    self?.isLoading = true
                })
        ])
        
        let output = viewModel.output
        disposeBag.insert([
            output
                .onDisplay
                .subscribe(onNext: { [weak self] articles in
                    self?.isLoading = false
                    self?.hideLoading()
                    if articles.isEmpty && self?.articles.isEmpty ?? true {
                        self?.showEmptyView()
                    } else {
                        self?.setupDisplay(articles: articles)
                    }
                }),
            output
                .onError
                .subscribe(onNext: { [weak self] error in
                    self?.isLoading = false
                    self?.showError(error: error)
                    self?.hideLoading()
                    if self?.articles.isEmpty ?? true {
                        self?.showEmptyView()
                    }
                })
        ])
    }
    
    func setupDisplay(articles: Pagination<Article>) {
        self.articles.append(articles)
        newsTableView.reloadData()
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isLoading && articles.isEmpty) ? 3 : articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NewsTableCell.self)
        if isLoading {
            cell.showAnimatedGradientSkeleton()
        } else {
            cell.hideSkeleton()
            cell.setupCell(article: articles.data[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isLoading,
           indexPath.row > articles.count - 3,
           articles.canLoadmore {
            isLoading = true
            viewModel.input.onPage.onNext(articles.currentPage + 1)
        }
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.onNext.onNext(articles.data[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        func collapseHeader() {
            UIView.animate(
                withDuration: 0.35,
                animations: {
                    self.headerView.alpha = 0
                    self.headerViewHeight.constant = 0
                },
                completion: nil
            )
        }
        func expandHeader() {
            UIView.animate(
                withDuration: 0.35,
                animations: {
                    self.headerView.alpha = 1
                    self.headerViewHeight.constant = 159
                },
                completion: nil
            )
        }
        let scrollVelocity = scrollView.panGestureRecognizer.velocity(in: view)
        if scrollVelocity.y < -2000 {
            collapseHeader()
            searchTextField.resignFirstResponder()
        } else if scrollVelocity.y > 0 {
            expandHeader()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.refreshControl.endRefreshing()
            },
            completion: nil
        )
    }
}

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let articlesPreloadIfNeed = indexPaths.compactMap({ articles.data[$0.row].url }).compactMap({ URL(string: $0) })
        viewModel.input.onPreloadImage.onNext(articlesPreloadIfNeed)
    }
}
