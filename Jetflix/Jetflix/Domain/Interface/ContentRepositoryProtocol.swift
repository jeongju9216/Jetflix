//
//  TitleRepositoryProtocol.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

protocol ContentRepositoryProtocol {
    //TMDB API get
    func getContents(type: APIType) async throws -> [Content]
    
    //Search
    func search(with query: String) async throws -> [Content]
    func getMovieFromYoutube(with query: String) async throws -> VideoElement
    
    //CoreData
    func saveWith(content: Content) async throws
    func fetchDownloadsContents() async throws -> [Content]
    func delete(content: Content) async throws
}
