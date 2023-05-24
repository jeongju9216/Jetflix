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
    private var searchMemoryCache: [String: [Content]] = [:]
}

//MARK: - Fetch TBMS Data
extension ContentRepository {
    func getContents(type: ContentType, page: Int) async throws -> [Content] {
        switch type {
        case .trending(let mediaType):
            switch mediaType {
            case .movie:
                return try await apiCaller.getTrendingContent(type: .movie)
            case .tv:
                return try await apiCaller.getTrendingContent(type: .tv)
            }
        case .upcoming:
            return try await apiCaller.getUpcomingMovie(page: page)
        case .popular:
            return try await apiCaller.getPopularMovie()
        case .topRated:
            return try await apiCaller.getTopRatedMovie()
        case .discover:
            return try await apiCaller.getDiscoverMovie()
        }
    }
}

//MARK: - Search
extension ContentRepository {
    func search(with query: String) async throws -> [Content] {
        if let cache = searchMemoryCache[query] {
            return cache
        }
        
        let contents = try await apiCaller.search(with: query)
        searchMemoryCache[query] = contents
        
        return contents
    }
}

//MARK: - CoreData
extension ContentRepository {
    func saveWith(content: Content) throws {
        try contentStorage.downloadWith(model: content)
    }
    
    func fetchDownloadsContents() throws -> [Content] {
        try contentStorage.fetchContentsFromCoreData()
    }
    
    func delete(content: Content) throws {
        try contentStorage.delete(model: content)
    }
}
