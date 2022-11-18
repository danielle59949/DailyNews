//
//  NewsTableCell.swift
//  News
//
//  Created by Daniel Le on 18/11/2022.
//

import UIKit
import Reusable
import Kingfisher
import BaseUI
import SkeletonView

class NewsTableCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var newsPublishedAtImageView: UIImageView!
    @IBOutlet private weak var newsPublishedAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.isSkeletonable = true
        
        newsImageView.cornerRadius = 8
        newsImageView.isSkeletonable = true
        newsImageView.skeletonCornerRadius = 8
        
        newsTitleLabel.isSkeletonable = true
        newsTitleLabel.linesCornerRadius = 4
        
        newsPublishedAtImageView.isSkeletonable = true
        newsPublishedAtImageView.skeletonCornerRadius = 4
        
        newsPublishedAtLabel.isSkeletonable = true
    }
    
    func setupCell(article: Article) {
        newsImageView.kf.setImage(
            with: URL(string: article.urlToImage ?? ""),
            placeholder: UIImage(named: "news_thumbnail", in: Bundle(for: NewsDetailViewController.self), compatibleWith: nil)
        )
        newsTitleLabel.text = article.title
        newsPublishedAtLabel.text = article.displayPublishedAt()
    }
}
