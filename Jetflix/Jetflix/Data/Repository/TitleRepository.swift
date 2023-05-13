//
//  TitleRepository.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

final class TitleRepository: TitleRepositoryProtocol {
    func getTrendingTitle() async throws -> [Title] {
        let titleDTO = try await APICaller.shared.getTrendingTitles(type: .all).results
        return titleDTO.map { $0.toEntity() }
    }
}
