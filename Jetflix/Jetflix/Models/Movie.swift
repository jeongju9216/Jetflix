//
//  Movie.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

struct TrendingMoviesResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

/*
 Movie(id: 552688, media_type: Optional("movie"), original_title: Optional("The Mother"), poster_path: Optional("/vnRthEZz16Q9VWcP5homkHxyHoy.jpg"), overview: Optional("A deadly female assassin comes out of hiding to protect the daughter that she gave up years before, while on the run from dangerous men."), vote_count: 75, release_date: Optional("2023-05-04"), vote_average: 6.473)
 */
