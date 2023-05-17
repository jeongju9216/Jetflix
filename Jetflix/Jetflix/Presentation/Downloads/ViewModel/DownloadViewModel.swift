//
//  DownloadViewModel.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/16.
//

import Foundation
import Combine

enum DownloadViewModelActions {
    case fetchDownloadContents
    case delete(Int)
}

final class DownloadViewModel {
    private var fetchDownloadContentUseCase: FetchDownloadContentUseCase
    private var deleteContentUseCase: DeleteContentUseCase
    
    @Published private(set) var contents: [Content] = []
    
    init(fetchDownloadContentUseCase: FetchDownloadContentUseCase, deleteContentUseCase: DeleteContentUseCase) {
        self.fetchDownloadContentUseCase = fetchDownloadContentUseCase
        self.deleteContentUseCase = deleteContentUseCase
    }
    
    func action(_ actions: DownloadViewModelActions) {
        switch actions {
        case .fetchDownloadContents:
            fetchDownloadContents()
        case .delete(let index):
            delete(at: index)
        }
    }
}

extension DownloadViewModel {
    private func fetchDownloadContents() {
        Task {
            do {
                contents = try fetchDownloadContentUseCase.excute()
            } catch {
                contents = []
            }
        }
    }
    
    private func delete(at index: Int) {
        do {
            try deleteContentUseCase.excute(requestValue: contents[index])
            contents.remove(at: index)
        } catch {
        }
    }
}
