//
//  YoutubeRepository.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/16.
//

import Foundation

final class YoutubeRepository: YoutubeRepositoryProtocol {
    private let apiCaller = APICaller.shared
    private var memoryCache: [String: VideoElement] = [:]
    
    func getMovieTrailer(title: String) async throws -> VideoElement {
        if let cache = memoryCache[title] {
            return cache
        }
        
        let videoElement = try await apiCaller.getMovieFromYoutube(with: title)
        memoryCache[title] = videoElement
        
        return videoElement
    }
}
