//
//  NewsEmptyView.swift
//  News
//
//  Created by Daniel Le on 18/11/2022.
//

import BaseUI
import RxSwift

class NewsEmptyView: BaseNibView {
    @IBOutlet private var reloadButton: UIButton!
    
    var onReload = PublishSubject<Void>()
    var disposeBag = DisposeBag()
    
    override func setupViews() {
        reloadButton.cornerRadius = 8
        reloadButton
            .rx
            .tap
            .bind(to: onReload)
            .disposed(by: disposeBag)
    }
}
