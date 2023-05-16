//
//  YoutubeRepository.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/16.
//

import Foundation

final class YoutubeRepository: YoutubeRepositoryProtocol {
    private let apiCaller = APICaller.shared
    
    func getMovieTrailer(title: String) async throws -> VideoElement {
        return try await apiCaller.getMovieFromYoutube(with: title)
    }
}
