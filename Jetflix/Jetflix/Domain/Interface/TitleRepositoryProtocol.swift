//
//  TitleRepositoryProtocol.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

protocol ContentRepositoryProtocol {
    func getTrendingMovie() async throws -> [Movie]
    func getTrendingTv() async throws -> [Tv]
}
