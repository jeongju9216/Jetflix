//
//  GetContentUseCase.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/17.
//

import Foundation

struct GetContentUseCase: GetContentUseCaseProtocol {
    typealias RequestType = ContentType
    typealias ResponseType = [Content]
    
    var repository: ContentRepositoryProtocol
    
    func excute(requestValue: RequestType) async throws -> ResponseType {
        return try await repository.getContents(type: requestValue)
    }
}

struct FetchDownloadContentUseCase: FetchDownloadContentUseCaseProtocol {
    typealias ResponseType = [Content]
    
    var repository: ContentRepositoryProtocol
    
    func excute() throws -> ResponseType {
        return try repository.fetchDownloadsContents()
    }
}

struct SaveContentUseCase: SaveContentUseCaseProtocol {
    typealias RequestType = Content
    
    var repository: ContentRepositoryProtocol
    
    func excute(requestValue: RequestType) throws {
        try repository.saveWith(content: requestValue)
    }

}

struct DeleteContentUseCase: DeleteContentUseCaseProtocol {
    typealias RequestType = Content
    
    var repository: ContentRepositoryProtocol
    
    func excute(requestValue: RequestType) throws {
        try repository.delete(content: requestValue)
    }
}

struct SearchContentUseCase: SearchContentUseCaseProtocol {
    typealias RequestType = String
    
    typealias ResponseType = [Content]
    
    var repository: ContentRepositoryProtocol
    
    func excute(requestValue: RequestType) async throws -> ResponseType {
        return try await repository.search(with: requestValue)
    }
}
