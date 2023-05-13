//
//  TitleRepository.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

final class ContentRepository: ContentRepositoryProtocol {
    func getTrendingMovie() async throws -> [Movie] {
        let contents = try await APICaller.shared.getTrendingContent(type: .movie).results
        let movies: [Movie] = contents.compactMap { $0.toEntity() as? Movie }
        return movies
    }
    
    func getTrendingTv() async throws -> [Tv] {
        let contents = try await APICaller.shared.getTrendingContent(type: .tv).results
        let tvs: [Tv] = contents.compactMap { $0.toEntity() as? Tv }
        return tvs
    }
    
    
}
