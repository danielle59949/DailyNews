//
//  Article.swift
//  News
//
//  Created by Daniel Le on 18/11/2022.
//

class ArticleResponse: Decodable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
}


class Article: Decodable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    func displayPublishedAt() -> String? {
        let date = publishedAt?.date(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        return date?.string(format: "dd MMM yyyy, HH:mm:ss")
    }
}

class Source: Decodable {
    var id: String?
    var name: String?
}
