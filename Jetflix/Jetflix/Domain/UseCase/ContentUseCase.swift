//
//  GetContentUseCase.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/17.
//

import Foundation

class ContentUseCase: ContentUseCaseProtocol {
    @Dependency var repository: ContentRepositoryProtocol
}

final class GetContentUseCase: ContentUseCase, GetContentUseCaseProtocol {
    typealias RequestType = ContentType
    typealias ResponseType = [Content]
    
    func excute(requestValue: RequestType) async throws -> ResponseType {
        return try await repository.getContents(type: requestValue)
    }
}

final class FetchDownloadContentUseCase: ContentUseCase, FetchDownloadContentUseCaseProtocol {
    typealias ResponseType = [Content]
    
    func excute() throws -> ResponseType {
        return try repository.fetchDownloadsContents()
    }
}

final class SaveContentUseCase: ContentUseCase, SaveContentUseCaseProtocol {
    typealias RequestType = Content
    
    func excute(requestValue: RequestType) throws {
        try repository.saveWith(content: requestValue)
    }

}

final class DeleteContentUseCase: ContentUseCase, DeleteContentUseCaseProtocol {
    typealias RequestType = Content
    
    func excute(requestValue: RequestType) throws {
        try repository.delete(content: requestValue)
    }
}

final class SearchContentUseCase: ContentUseCase, SearchContentUseCaseProtocol {
    typealias RequestType = String
    typealias ResponseType = [Content]
    
    func excute(requestValue: RequestType) async throws -> ResponseType {
        return try await repository.search(with: requestValue)
    }
}
