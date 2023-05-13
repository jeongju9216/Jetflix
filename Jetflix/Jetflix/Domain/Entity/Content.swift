//
//  Title.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

enum ContentType: String {
    case all
    case movie
    case tv
}

protocol Contentable {
    var id: Int { get set }
}

struct Movie: Contentable, Hashable {
    var id: Int
    let adult: Bool?
    let mediaType: String?
    let title, originalTitle, overview: String?
    var posterPath: String?
    let popularity: Double?
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}

struct Tv: Contentable, Hashable {
    var id: Int
    let adult: Bool?
    let mediaType: String?
    let name, originalName, overview: String?
    let posterPath: String?
    let popularity: Double?
    let firstAirDate: String?
    let voteAverage: Double?
    let voteCount: Int?
}
