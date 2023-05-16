//
//  HomeViewModel.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/16.
//

import Foundation
import Combine

enum HomeViewModelActions {
    case getContents(ContentType)
    case getRandomTrendingContent
    case save(Content)
    case fetchDownloadContents
    case delete(Content)
}

enum HomeViewModelActionsOutput {
    case contents([Content])
    case isSuccess(Bool)
    case none(Void)
    
    var value: Any {
        switch self {
        case .contents(let contents):
            return contents
        case .isSuccess(let isSuccess):
            return isSuccess
        case .none():
            return ()
        }
    }
}

final class HomeViewModel {
    private var contentRepository: ContentRepositoryProtocol

    @Published private(set) var randomTrendingContent: Content?

    //MARK: - Init
    init(contentRepository: ContentRepositoryProtocol) {
        self.contentRepository = contentRepository
    }
    
    //MARK: - Actions
    @discardableResult
    func action(_ actions: HomeViewModelActions) async throws -> HomeViewModelActionsOutput {
        switch actions {
        case .getContents(let contentType):
            return .contents(try await getContents(type: contentType))
        case .getRandomTrendingContent:
            getRandomTrendingContent()
            return .none(())
        case .save(let content):
            return .isSuccess(save(content: content))
        case .fetchDownloadContents:
            return .contents(try fetchDownloadContents())
        case .delete(let content):
            return .isSuccess(delete(content: content))
        }
    }
}

extension HomeViewModel {
    //MARK: - Methods
    private func getContents(type: ContentType) async throws -> [Content] {
        return try await contentRepository.getContents(type: type)
    }
    
    private func getRandomTrendingContent() {
        Task {
            randomTrendingContent = try? await getContents(type: .trending(.movie)).randomElement()
        }
    }
    
    private func fetchDownloadContents() throws -> [Content] {
        return try contentRepository.fetchDownloadsContents()
    }
    
    private func save(content: Content) -> Bool {
        do {
            try contentRepository.saveWith(content: content)
            return true
        } catch {
            return false
        }
    }
    
    private func delete(content: Content) -> Bool {
        do {
            try contentRepository.delete(content: content)
            return true
        } catch {
            return false
        }
    }
}
