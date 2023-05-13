//
//  TitleRepository.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

final class ContentRepository: ContentRepositoryProtocol {
    func getTrendingMovie() async throws -> [Movie] {
        let movies: [Movie] = try await APICaller.shared.getTrendingContent(type: .movie).compactMap { $0 as? Movie }
        return movies
    }
    
    func getTrendingTv() async throws -> [Tv] {
        let tvs = try await APICaller.shared.getTrendingContent(type: .tv).compactMap { $0 as? Tv }
        return tvs
    }
    
    func getUpcomingMovies() async throws -> [Movie] {
        let movies: [Movie] = try await APICaller.shared.getUpcomingMovie()
        return movies
    }
    
    func getPopularMovies() async throws -> [Movie] {
        let movies: [Movie] = try await APICaller.shared.getPopularMovie()
        return movies
    }
    
    func getTopRatedMovies() async throws -> [Movie] {
        let movies: [Movie] = try await APICaller.shared.getTopRatedMovie()
        return movies
    }
}
