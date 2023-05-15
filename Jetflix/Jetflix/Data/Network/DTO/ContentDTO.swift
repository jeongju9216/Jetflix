//
//  TitleDTO.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

struct TMDBResponse: Decodable {
    let results: [ContentDTO]
}

struct TMDBMovieResponse: Decodable {
    let results: [MovieDTO]
}

enum ContentDTO {
    case movie(MovieDTO)
    case tv(TvDTO)
    
    func toEntity() -> Content? {
        switch self {
        case .movie(let movieDTO):
            return movieDTO.toEntity()
        case .tv(let tvDTO):
            return tvDTO.toEntity()
        }
    }
}

extension ContentDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let singleContainer = try decoder.singleValueContainer()
        
        let type = try container.decode(String.self, forKey: .mediaType)
        switch type {
        case "movie":
            let movieDTO = try singleContainer.decode(MovieDTO.self)
            self = .movie(movieDTO)
        case "tv":
            let tvDTO = try singleContainer.decode(TvDTO.self)
            self = .tv(tvDTO)
        default:
            fatalError()
        }
    }
}

struct MovieDTO: Codable {
    let adult: Bool?
    let backdropPath: String?
    let id: Int?
    let title, originalLanguage, originalTitle, overview: String?
    let posterPath, mediaType: String?
    let genreIDS: [Int]?
    let popularity: Double?
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func toEntity() -> Content? {
        guard let id = id else { return nil }
        
        return .init(id: id,
                     mediaType: .movie,
                     adult: adult,
                     title: title,
                     originalTitle: originalTitle,
                     overview: overview,
                     posterPath: posterPath,
                     popularity: popularity,
                     releaseDate: releaseDate,
                     voteAverage: voteAverage,
                     voteCount: voteCount)
    }
}

struct TvDTO: Codable {
    let adult: Bool?
    let backdropPath: String?
    let id: Int?
    let name, originalLanguage, originalName, overview: String?
    let posterPath, mediaType: String?
    let genreIDS: [Int]?
    let popularity: Double?
    let firstAirDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let originCountry: [String]?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, name
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
    }
    
    func toEntity() -> Content? {
        guard let id = id else { return nil }

        return .init(id: id,
                     mediaType: .tv,
                     adult: adult,
                     title: name,
                     originalTitle: originalName,
                     overview: overview,
                     posterPath: posterPath,
                     popularity: popularity,
                     releaseDate: firstAirDate,
                     voteAverage: voteAverage,
                     voteCount: voteCount)
    }
}

