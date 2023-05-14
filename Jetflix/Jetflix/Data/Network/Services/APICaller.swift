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
        let urlString = "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&include_adult=true&page=1&sort_by=popularity.desc"
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

//MARK: - Search
extension APICaller {
    //https://api.themoviedb.org/3/search/movie
    //https://api.themoviedb.org/3/search/multi
    func search(with query: String) async throws -> [Movie] {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { throw APIError.urlError }
        
        let urlString = "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)&include_adult=true&page=1"
        guard let url = URL(string: urlString) else { throw APIError.urlError }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            let contents = try JSONDecoder().decode(TMDBMovieResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() as Movie }
        } catch {
            throw APIError.failedTargetData
        }
    }
}
