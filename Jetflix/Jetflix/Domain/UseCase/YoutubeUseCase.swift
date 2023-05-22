//
//  YoutubeUseCaseProtocol.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/17.
//

import Foundation

struct SearchYoutubeUseCase: SearchYoutubeUseCaseProtocol {
    typealias RequestType = String
    typealias ResponseType = VideoElement
    
    @Dependency var repository: YoutubeRepositoryProtocol
    
    func excute(requestValue: RequestType) async throws -> ResponseType {
        return try await repository.getMovieTrailer(title: requestValue)
    }
}
