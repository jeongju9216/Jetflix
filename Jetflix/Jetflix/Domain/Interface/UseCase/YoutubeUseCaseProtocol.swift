//
//  YoutubeUseCaseProtocol.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/17.
//

import Foundation

protocol YoutubeUseCaseProtocol {
    var repository: YoutubeRepositoryProtocol { get }
}

protocol SearchYoutubeUseCaseProtocol {
    associatedtype RequestType
    associatedtype ResponseType
    
    func excute(requestValue: RequestType) async throws -> ResponseType
}
