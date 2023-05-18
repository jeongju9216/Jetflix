//
//  UpcomingViewModel.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/16.
//

import Foundation

enum UpcommingViewModelActions {
    case fetchContents
    case save(Content)

}

final class UpcommingViewModel {
    private var getContentUseCase: GetContentUseCase
    private var saveContentUseCase: SaveContentUseCase
    @Published private(set) var contents: [Content] = []
    
    init(getContentUseCase: GetContentUseCase, saveContentUseCase: SaveContentUseCase) {
        self.getContentUseCase = getContentUseCase
        self.saveContentUseCase = saveContentUseCase
    }
    
    func action(_ actions: UpcommingViewModelActions) {
        switch actions {
        case .fetchContents:
            fetchContents()
        case .save(let content):
            let _ = save(content: content)
        }
    }
}

extension UpcommingViewModel {
    private func fetchContents() {
        Task {
            do {
                contents = try await getContentUseCase.excute(requestValue: .upcoming)
            } catch {
                contents = []
            }
        }
    }
    
    private func save(content: Content) -> Bool {
        do {
            try saveContentUseCase.excute(requestValue: content)
            return true
        } catch {
            return false
        }
    }
}
