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
    func getTrendingMovie() async throws -> [Movie]
    func getTrendingTv() async throws -> [Tv]
    func getUpcomingMovies() async throws -> [Movie]
    func getPopularMovies() async throws -> [Movie]
    func getTopRatedMovies() async throws -> [Movie]
    func getDiscoverMovies() async throws -> [Movie]
    
    func search(with query: String) async throws -> [Movie]
    func getMovieFromYoutube(with query: String) async throws -> VideoElement
}
