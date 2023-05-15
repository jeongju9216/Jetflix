//
//  TitleRepository.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

final class ContentRepository: ContentRepositoryProtocol {
    func getTrendingMovie() async throws -> [Content] {
        let movies: [Content] = try await APICaller.shared.getTrendingContent(type: .movie)
        return movies
    }
    
    func getTrendingTv() async throws -> [Content] {
        let tvs: [Content] = try await APICaller.shared.getTrendingContent(type: .tv)
        return tvs
    }
    
    func getUpcomingMovies() async throws -> [Content] {
        let movies: [Content] = try await APICaller.shared.getUpcomingMovie()
        return movies
    }
    
    func getPopularMovies() async throws -> [Content] {
        let movies: [Content] = try await APICaller.shared.getPopularMovie()
        return movies
    }
    
    func getTopRatedMovies() async throws -> [Content] {
        let movies: [Content] = try await APICaller.shared.getTopRatedMovie()
        return movies
    }
    
    func getDiscoverMovies() async throws -> [Content] {
        let movies: [Content] = try await APICaller.shared.getDiscoverMovie()
        return movies
    }
}

extension ContentRepository {
    func search(with query: String) async throws -> [Content] {
        return try await APICaller.shared.search(with: query)
    }
    
    func getMovieFromYoutube(with query: String) async throws -> VideoElement {
        return try await APICaller.shared.getMovieFromYoutube(with: query)
    }
}
