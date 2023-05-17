//
//  ContentUseCaseProtocol.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/17.
//

import Foundation

protocol ContentUseCaseProtocol {
    var repository: ContentRepositoryProtocol { get }
}

protocol GetContentUseCaseProtocol: ContentUseCaseProtocol {
    associatedtype RequestType
    associatedtype ResponseType
    
    func excute(requestValue: RequestType) async throws -> ResponseType
}

protocol FetchDownloadContentUseCaseProtocol: ContentUseCaseProtocol {
    associatedtype ResponseType
    
    func excute() throws -> ResponseType
}

protocol SaveContentUseCaseProtocol: ContentUseCaseProtocol {
    associatedtype RequestType
    
    func excute(requestValue: RequestType) throws
}

protocol DeleteContentUseCaseProtocol: ContentUseCaseProtocol {
    associatedtype RequestType
    
    func excute(requestValue: RequestType) throws
}

protocol SearchContentUseCaseProtocol: ContentUseCaseProtocol {
    associatedtype RequestType
    associatedtype ResponseType
    
    func excute(requestValue: RequestType) async throws -> ResponseType
}
