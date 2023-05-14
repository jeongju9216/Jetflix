//
//  YoutubeSearchResponseDTO.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/14.
//

import Foundation

struct YoutubeSearchResponseDTO: Codable {
    let kind: String?
    let etag: String?
    let nextPageToken: String?
    let regionCode: String?
    let items: [VideoElementDTO]?
}

struct VideoElementDTO: Codable {
    let kind: String?
    let etag: String?
    let id: IdVideoElementDTO?
    
    func toEntity() -> VideoElement? {
        guard let id = id?.toEntity() else { return nil }
        
        return .init(id: id)
    }
}

struct IdVideoElementDTO: Codable {
    let kind: String?
    let videoId: String?
    
    func toEntity() -> IdVideoElement? {
        guard let kind = kind, let videoId = videoId else { return nil }
        
        return .init(kind: kind, videoId: videoId)
    }
}
