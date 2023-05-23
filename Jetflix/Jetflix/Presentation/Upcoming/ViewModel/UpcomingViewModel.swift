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
    @Dependency private var getContentUseCase: GetContentUseCase
    @Dependency private var saveContentUseCase: SaveContentUseCase
    
    private var page = 1
    
    @Published private(set) var contents: [Content] = []
    
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
                print("fetchContents: \(page)")
                let newContents = try await getContentUseCase.excute(type: .upcoming, page: page)
                contents.append(contentsOf: newContents)
                page += 1
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
