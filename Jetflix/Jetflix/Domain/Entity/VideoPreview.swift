//
//  YoutubeItem.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/14.
//

import Foundation

struct VideoPreview {
    let title: String
    let youtubeView: VideoElement
    let titleOverview: String
}

struct VideoElement {
    let id: IdVideoElement
}

struct IdVideoElement {
    let kind: String
    let videoId: String
}
