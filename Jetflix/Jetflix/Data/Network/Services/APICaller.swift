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
    static let YOUTUBE_API_KEY = "AIzaSyCUl5y_4sWfpvt0hoLzV3boz83s6PtXVvo"
    static let youtubeBaseURL = "https://www.googleapis.com/youtube/v3/search"
}

enum APIType {
    case trending(ContentType)
    case upcoming
    case popular
    case topRated
    case discover
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

    func getTrendingContent(type: ContentType) async throws -> [Content] {
        let urlString = "\(Constants.baseURL)/3/trending/\(type.rawValue)/day?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let contents = try JSONDecoder().decode(TMDBResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() }
        } catch {
            throw APIError.failedTargetData
        }
    }
    
    func getUpcomingMovie() async throws -> [Content] {
        let urlString = "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let contents = try JSONDecoder().decode(TMDBMovieResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() }
        } catch {
            throw APIError.failedTargetData
        }

    }
    
    func getPopularMovie() async throws -> [Content] {
        let urlString = "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let contents = try JSONDecoder().decode(TMDBMovieResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() }
        } catch {
            throw APIError.failedTargetData
        }
    }
    
    func getTopRatedMovie() async throws -> [Content] {
        let urlString = "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let contents = try JSONDecoder().decode(TMDBMovieResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() }
        } catch {
            throw APIError.failedTargetData
        }
    }
    
    func getDiscoverMovie() async throws -> [Content] {
        let urlString = "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&include_adult=true&page=1&sort_by=popularity.desc"
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let contents = try JSONDecoder().decode(TMDBMovieResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() }
        } catch {
            throw APIError.failedTargetData
        }
    }
    
    func search(with query: String) async throws -> [Content] {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { throw APIError.urlError }
        
        let urlString = "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)&include_adult=true&page=1"
        guard let url = URL(string: urlString) else { throw APIError.urlError }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let contents = try JSONDecoder().decode(TMDBMovieResponse.self, from: data).results
            return contents.compactMap { $0.toEntity() }
        } catch {
            throw APIError.failedTargetData
        }
    }
}

//MARK: - Youtube Search
extension APICaller {
    func getMovieFromYoutube(with query: String) async throws -> VideoElement {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { throw APIError.urlError }

        let urlString = "\(Constants.youtubeBaseURL)?q=\(query)&key=\(Constants.YOUTUBE_API_KEY)"
        guard let url = URL(string: urlString) else { throw APIError.urlError }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let contents = try JSONDecoder().decode(YoutubeSearchResponseDTO.self, from: data).items,
                  let firstItem = contents.first?.toEntity() else {
                throw APIError.failedTargetData
            }
            
            return firstItem
        } catch {
            throw APIError.failedTargetData
        }
    }
}
