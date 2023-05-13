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

struct Movie: Hashable {
    let adult: Bool
    let id: Int
    let title, originalTitle, overview: String
    let posterPath, mediaType: String
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}

struct Tv: Hashable {
    let adult: Bool
    let id: Int
    let name, originalName, overview: String
    let posterPath, mediaType: String
    let popularity: Double
    let firstAirDate: String
    let voteAverage: Double
    let voteCount: Int
}
