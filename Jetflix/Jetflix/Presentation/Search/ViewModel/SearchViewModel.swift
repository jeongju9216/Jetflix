//
//  SearchViewModel.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/16.
//

import Foundation
import Combine

enum SearchViewModelActions {
    case fetchContents
    case search(String)
}

final class SearchViewModel {
    private var contentRepository: ContentRepositoryProtocol
    
    @Published private(set) var contents: [Content] = []
    @Published private(set) var searchResult: [Content] = []
    
    init(contentRepository: ContentRepositoryProtocol) {
        self.contentRepository = contentRepository
    }
    
    func action(_ actions: SearchViewModelActions) {
        switch actions {
        case .fetchContents:
            fetchContents()
        case .search(let query):
            search(query: query)
        }
    }
}

extension SearchViewModel {
    private func fetchContents() {
        Task {
            do {
                contents = try await contentRepository.getContents(type: .discover)
            } catch {
                contents = []
            }
        }
    }
    
    private func search(query: String) {
        Task {
            do {
                searchResult = try await contentRepository.search(with: query)
            } catch {
                searchResult = []
            }
        }
    }
}
