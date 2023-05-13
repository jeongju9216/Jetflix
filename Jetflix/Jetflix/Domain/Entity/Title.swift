//
//  Title.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

struct Title: Hashable {
    let id: Int
    let mediaType: String?
    let originalTitle: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int
    let voteAverage: Double
    let releaseDate: String?
}

enum TitleType: String {
    case all
    case movie
    case tv
}
