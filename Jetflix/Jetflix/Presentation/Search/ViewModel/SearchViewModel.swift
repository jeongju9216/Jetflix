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
    private var getContentUseCase: GetContentUseCase
    private var searchContentUseCase: SearchContentUseCase
    
    @Published private(set) var contents: [Content] = []
    @Published private(set) var searchResult: [Content] = []
    
    init(getContentUseCase: GetContentUseCase, searchContentUseCase: SearchContentUseCase) {
        self.getContentUseCase = getContentUseCase
        self.searchContentUseCase = searchContentUseCase
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
                contents = try await getContentUseCase.excute(requestValue: .discover)
            } catch {
                contents = []
            }
        }
    }
    
    private func search(query: String) {
        Task {
            do {
                searchResult = try await searchContentUseCase.excute(requestValue: query)
            } catch {
                searchResult = []
            }
        }
    }
}
