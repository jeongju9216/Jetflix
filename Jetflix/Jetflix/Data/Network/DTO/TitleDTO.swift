//
//  TitleDTO.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [TitleDTO]
}

struct TitleDTO: Codable {
    let id: Int
    let mediaType: String?
    let originalTitle: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int
    let voteAverage: Double
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case mediaType = "media_type"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case overview = "overview"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
    
    func toEntity() -> Title {
        return .init(id: id,
                     mediaType: mediaType,
                     originalTitle: originalTitle,
                     posterPath: posterPath,
                     overview: overview,
                     voteCount: voteCount,
                     voteAverage: voteAverage,
                     releaseDate: releaseDate)
    }
}

/*
 Movie(id: 552688, media_type: Optional("movie"), original_title: Optional("The Mother"), poster_path: Optional("/vnRthEZz16Q9VWcP5homkHxyHoy.jpg"), overview: Optional("A deadly female assassin comes out of hiding to protect the daughter that she gave up years before, while on the run from dangerous men."), vote_count: 75, release_date: Optional("2023-05-04"), vote_average: 6.473)
 */
