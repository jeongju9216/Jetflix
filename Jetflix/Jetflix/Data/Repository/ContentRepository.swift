//
//  TitleRepository.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

final class ContentRepository: ContentRepositoryProtocol {
    private let apiCaller = APICaller.shared
    private let contentStorage = ContentStorage()
}

//MARK: - Fetch TBMS Data
extension ContentRepository {
    func getTrendingMovie() async throws -> [Content] {
        let movies: [Content] = try await apiCaller.getTrendingContent(type: .movie)
        return movies
    }
    
    func getTrendingTv() async throws -> [Content] {
        let tvs: [Content] = try await apiCaller.getTrendingContent(type: .tv)
        return tvs
    }
    
    func getUpcomingMovies() async throws -> [Content] {
        let movies: [Content] = try await apiCaller.getUpcomingMovie()
        return movies
    }
    
    func getPopularMovies() async throws -> [Content] {
        let movies: [Content] = try await apiCaller.getPopularMovie()
        return movies
    }
    
    func getTopRatedMovies() async throws -> [Content] {
        let movies: [Content] = try await apiCaller.getTopRatedMovie()
        return movies
    }
    
    func getDiscoverMovies() async throws -> [Content] {
        let movies: [Content] = try await apiCaller.getDiscoverMovie()
        return movies
    }
}

//MARK: - Search
extension ContentRepository {
    func search(with query: String) async throws -> [Content] {
        return try await apiCaller.search(with: query)
    }
    
    func getMovieFromYoutube(with query: String) async throws -> VideoElement {
        return try await apiCaller.getMovieFromYoutube(with: query)
    }
}

//MARK: - CoreData
extension ContentRepository {
    func saveContentWith(content: Content) async throws {
        try await contentStorage.downloadWith(model: content)
    }
    
    func fetchDownloadsContents() async throws -> [Content] {
        try await contentStorage.fetchContentsFromCoreData()
    }
    
    func deleteContentWith(content: Content) async throws {
        try await contentStorage.delete(model: content)
    }
}
