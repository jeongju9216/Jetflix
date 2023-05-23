//
//  TitleRepositoryProtocol.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import Foundation

protocol ContentRepositoryProtocol {
    //TMDB API get
    func getContents(type: ContentType, page: Int) async throws -> [Content]
    
    //Search
    func search(with query: String) async throws -> [Content]
    
    //CoreData
    func saveWith(content: Content) throws
    func fetchDownloadsContents() throws -> [Content]
    func delete(content: Content) throws
}
