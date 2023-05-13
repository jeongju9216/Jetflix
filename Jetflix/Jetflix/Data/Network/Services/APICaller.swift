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
    func getTrendingTitles(type: TitleType) async throws -> TrendingTitleResponse {
        let urlString = "\(Constants.baseURL)/3/trending/\(type.rawValue)/day?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
        } catch {
            throw APIError.failedTargetData
        }
    }
}
