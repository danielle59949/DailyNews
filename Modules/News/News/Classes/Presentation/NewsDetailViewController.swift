//
//  NewsDetailViewController.swift
//  News
//
//  Created by Daniel Le on 18/11/2022.
//

import UIKit
import BaseUI
import Kingfisher
import RxSwift
import Helper

class NewsDetailViewController: BaseViewController {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var sourceButton: UIButton!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsPublishedAtLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsContentLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    private let disposeBag = DisposeBag()
    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observe()
    }
    
    private func setupViews() {
        newsImageView.kf.setImage(
            with: URL(string: article.urlToImage ?? ""),
            placeholder: UIImage(named: "news_thumbnail", in: Bundle(for: NewsDetailViewController.self), compatibleWith: nil),
            completionHandler: { [weak self] _ in
                UIView.animate(withDuration: 1.0) {
                    self?.newsImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
            }
        )
        sourceButton.cornerRadius = 8
        sourceButton.setAttributedTitle(
            NSAttributedString(
                string: article.source?.name ?? "",
                attributes: [.foregroundColor: UIColor.white,
                             .font: UIFont.systemFont(ofSize: 16.0),
                             .underlineStyle: NSUnderlineStyle.single.rawValue]
            ),
            for: .normal
        )
        newsTitleLabel.text = article.title
        newsPublishedAtLabel.text = article.displayPublishedAt()
        newsDescriptionLabel.text = article.description
        newsContentLabel.text = article.content
    }
    
    private func observe() {
        backButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        sourceButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                guard let url = URL(string: self?.article.url ?? "") else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            .disposed(by: disposeBag)
    }
}
