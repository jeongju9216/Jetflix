//
//  APICaller.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

struct Constants {
    static let API_KEY = "47b5d11235d6d701c40eebc30b1f27f4"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error {
    case urlError
    case failedTargetData
}

enum HTTPMethod: String {
    case get = "GET"
//    case post = "POST"
}

final class APICaller {
    static let shared = APICaller()
    
    private init() { }

    //https://api.themoviedb.org/3/trending/movie/day?api_key=
    //https://api.themoviedb.org/3/trending/all/day?api_key=
    func getTrendingContent(type: ContentType) async throws -> [Contentable] {
        let urlString = "\(Constants.baseURL)/3/trending/\(type.rawValue)/day?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let contents = try JSONDecoder().decode(TMDBResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() }
        } catch {
            throw APIError.failedTargetData
        }
    }
    
    //https://api.themoviedb.org/3/movie/upcoming?api_key=
    func getUpcomingMovie() async throws -> [Movie] {
        let urlString = "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            let contents = try JSONDecoder().decode(TMDBMovieResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() as Movie }
        } catch {
            throw APIError.failedTargetData
        }

    }
    
    //https://api.themoviedb.org/3/movie/popular
    func getPopularMovie() async throws -> [Movie] {
        let urlString = "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            let contents = try JSONDecoder().decode(TMDBMovieResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() as Movie }
        } catch {
            throw APIError.failedTargetData
        }
    }
    
    //https://api.themoviedb.org/3/movie/top_rated
    func getTopRatedMovie() async throws -> [Movie] {
        let urlString = "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            let contents = try JSONDecoder().decode(TMDBMovieResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() as Movie }
        } catch {
            throw APIError.failedTargetData
        }
    }
    
    //https://api.themoviedb.org/3/discover/movie
    //https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language=en-US&page=1&sort_by=popularity.desc
    func getDiscoverMovie() async throws -> [Movie] {
        let urlString = "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&sort_by=popularity.desc"
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            let contents = try JSONDecoder().decode(TMDBMovieResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() as Movie }
        } catch {
            throw APIError.failedTargetData
        }
    }
}
