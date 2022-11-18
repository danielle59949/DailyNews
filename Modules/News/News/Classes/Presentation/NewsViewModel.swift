//
//  NewsViewModel.swift
//  News
//
//  Created by Daniel Le on 18/11/2022.
//

import Base
import RxSwift
import RxCocoa
import Helper
import Kingfisher
import Alamofire

class NewsViewModel: ViewModelType {
    var input: Input
    var output: Output
    
    private let onSearch = PublishSubject<String?>()
    private let onPage = PublishSubject<Int>()
    private let onDisplay = PublishSubject<Pagination<Article>>()
    private let onLoadmore = PublishSubject<Void>()
    private let onError = PublishSubject<Error>()
    private let onNext = PublishSubject<Article>()
    private let onRefresh = PublishSubject<Void>()
    private let onPreloadImage = PublishSubject<[URL]>()
    private let disposeBag = DisposeBag()
    
    private var dispatchWorkItem: DispatchWorkItem?
    private var currentRequest: CancelableRequest?
    private var pageSize: Int = 20
    
    struct Input {
        var onSearch: AnyObserver<String?>
        var onNext: AnyObserver<Article>
        var onRefresh: AnyObserver<Void>
        var onPreloadImage: AnyObserver<[URL]>
        var onPage: AnyObserver<Int>
    }
    
    struct Output {
        var onDisplay: Observable<Pagination<Article>>
        var onError: Observable<Error>
        var onNext: Observable<Article>
    }
    
    init() {
        input = Input(
            onSearch: onSearch.asObserver(),
            onNext: onNext.asObserver(),
            onRefresh: onRefresh.asObserver(),
            onPreloadImage: onPreloadImage.asObserver(),
            onPage: onPage.asObserver()
        )
        output = Output(
            onDisplay: onDisplay.asObservable(),
            onError: onError.compactMap({
                if $0.asAFError?.isExplicitlyCancelledError ?? false {
                    return nil
                }
                return $0
            }).asObservable(),
            onNext: onNext.asObservable()
        )
        observeInput()
    }
    
    private func observeInput() {
        disposeBag.insert([
            onPage
                .withLatestFrom(onSearch) { ($0, $1) }
                .subscribe(onNext: { [weak self] (page, keyword) in
                    self?.dispatchWorkItem?.cancel()
                    self?.dispatchWorkItem = nil
                    if let keyword = keyword, !keyword.isEmpty {
                        let dispatchWorkItem = DispatchWorkItem { [weak self] in
                            self?.searchNews(keyword: keyword, page: page)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: dispatchWorkItem)
                        self?.dispatchWorkItem = dispatchWorkItem
                    } else {
                        self?.getNews(page: page)
                    }
                }),
            onSearch
                .subscribe(onNext: { [weak self] _ in
                    self?.onPage.onNext(1)
                }),
            onRefresh
                .subscribe(onNext: { [weak self] in
                    self?.onPage.onNext(1)
                }),
            onPreloadImage
                .subscribe(onNext: { urls in
                    ImagePrefetcher(urls: urls).start()
                })
        ])
    }
    
    private func getNews(page: Int) {
        currentRequest?.cancel()
        let request = GetNewsRequest(page: page, pageSize: pageSize)
        currentRequest = request
        request
            .doRequest()
            .observe(on: MainScheduler.instance)
            .subscribe(on: SerialDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [weak self] response in
                let pagination = Pagination(
                    data: response.articles ?? [],
                    currentPage: page,
                    totalData: response.totalResults ?? 0
                )
                self?.onDisplay.onNext(pagination)
            }, onError: { [weak self] error in
                self?.onError.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func searchNews(keyword: String, page: Int) {
        currentRequest?.cancel()
        let request = SearchNewsRequest(keyword: keyword, page: page, pageSize: pageSize)
        currentRequest = request
        request
            .doRequest()
            .observe(on: MainScheduler.instance)
            .subscribe(on: SerialDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [weak self] response in
                let pagination = Pagination(
                    data: response.articles ?? [],
                    currentPage: page,
                    totalData: response.totalResults ?? 0
                )
                self?.onDisplay.onNext(pagination)
            }, onError: { [weak self] error in
                self?.onError.onNext(error)
            })
            .disposed(by: disposeBag)
    }
}
