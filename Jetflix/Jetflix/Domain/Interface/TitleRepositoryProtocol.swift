//
//  TitleRepositoryProtocol.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

protocol TitleRepositoryProtocol {
    func getTrendingTitle() async throws -> [Title]
}
