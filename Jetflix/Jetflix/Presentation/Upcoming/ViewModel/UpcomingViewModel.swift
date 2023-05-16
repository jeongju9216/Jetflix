//
//  UpcomingViewModel.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/16.
//

import Foundation

enum UpcommingViewModelActions {
    case fetchContents
}

final class UpcommingViewModel {
    private var contentRepository: ContentRepositoryProtocol
    @Published private(set) var contents: [Content] = []
    
    init(contentRepository: ContentRepositoryProtocol) {
        self.contentRepository = contentRepository
    }
    
    func action(_ actions: UpcommingViewModelActions) {
        switch actions {
        case .fetchContents:
            fetchContents()
        }
    }
}

extension UpcommingViewModel {
    private func fetchContents() {
        Task {
            do {
                contents = try await contentRepository.getContents(type: .upcoming)
            } catch {
                contents = []
            }
        }
    }
}
