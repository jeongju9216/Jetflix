//
//  VideoPreviewViewModel.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/16.
//

import Foundation
import Combine

enum VideoPreviewViewModelActions {
    case getMovieTrailer(String)
}

final class VideoPreviewViewModel {
    @Dependency private var searchYoutubeUseCase: SearchYoutubeUseCase
    
    @Published private(set) var trailerVideoElement: VideoElement?
    
    func action(_ actions: VideoPreviewViewModelActions) {
        switch actions {
        case .getMovieTrailer(let title):
            getMovieTrailer(title: title + " Trailer")
        }
    }
}

extension VideoPreviewViewModel {
    private func getMovieTrailer(title: String) {
        Task {
            trailerVideoElement = try? await searchYoutubeUseCase.excute(requestValue: title)
        }
    }
}
