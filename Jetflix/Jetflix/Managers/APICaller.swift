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
    case failedTargetData
}

class APICaller {
    static let shared = APICaller()
    
    private init() { }

    //https://api.themoviedb.org/3/trending/movie/day?api_key=
    //https://api.themoviedb.org/3/trending/all/day?api_key=
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/all/day?api_key=\(Constants.API_KEY)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
