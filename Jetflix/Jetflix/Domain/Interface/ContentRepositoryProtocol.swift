//
//  TitleRepositoryProtocol.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

//todo: action으로 메서드 공통화
//todo: Contentable로 반환값 공통화
protocol ContentRepositoryProtocol {
    func getTrendingMovie() async throws -> [Content]
    func getTrendingTv() async throws -> [Content]
    func getUpcomingMovies() async throws -> [Content]
    func getPopularMovies() async throws -> [Content]
    func getTopRatedMovies() async throws -> [Content]
    func getDiscoverMovies() async throws -> [Content]
    
    func search(with query: String) async throws -> [Content]
    func getMovieFromYoutube(with query: String) async throws -> VideoElement
}
