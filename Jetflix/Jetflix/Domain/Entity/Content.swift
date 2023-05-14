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
    var posterPath: String? { get set }
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
    
    var displayTitle: String {
        return originalTitle ?? title ?? "Unknown"
    }
    
    var posterURL: String? {
        guard let posterPath = posterPath else { return nil }
        
        return "https://image.tmdb.org/t/p/w500" + posterPath
    }
}

struct Tv: Contentable, Hashable {
    var id: Int
    let adult: Bool?
    let mediaType: String?
    let name, originalName, overview: String?
    var posterPath: String?
    let popularity: Double?
    let firstAirDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    var displayName: String {
        return originalName ?? name ?? "Unknown"
    }
    
    var posterURL: String? {
        guard let posterPath = posterPath else { return nil }
        
        return "https://image.tmdb.org/t/p/w500" + posterPath
    }
}
