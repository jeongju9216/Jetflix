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
    private var contentRepository: ContentRepositoryProtocol
    
    @Published private(set) var contents: [Content] = []
    
    init(contentRepository: ContentRepositoryProtocol) {
        self.contentRepository = contentRepository
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
                contents = try contentRepository.fetchDownloadsContents()
            } catch {
                contents = []
            }
        }
    }
    
    private func delete(at index: Int) {
        do {
            try contentRepository.delete(content: contents[index])
            contents.remove(at: index)
        } catch {
        }
    }
}
