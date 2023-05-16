//
//  YoutubeRepositoryProtocol.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/16.
//

import Foundation

protocol YoutubeRepositoryProtocol {
    func getMovieTrailer(title: String) async throws -> VideoElement
}
