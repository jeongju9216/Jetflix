//
//  Content.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

enum ContentType {
    case trending(MediaType)
    case upcoming
    case popular
    case topRated
    case discover
}

enum MediaType: String {
    case movie
    case tv
}

struct Content: Hashable {
    let id: Int
    let mediaType: MediaType
    let adult: Bool?
    let title: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let popularity: Double?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    var displayTitle: String { title ?? originalTitle ?? "Unknown" }
    var displayOverView: String { overview ?? "None" }
    var posterURLString: String? { posterPath == nil ? nil : "https://image.tmdb.org/t/p/w500" + posterPath! }
}

