//
//  SceneDelegate.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        registercContentDependencies()
        registerYoutubeDependencies()
        registerViewModel()
        
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = MainTabBarViewController()
        window?.makeKeyAndVisible()
    }
    
    private func registercContentDependencies() {
        DIContainer.shared.register(type: ContentRepositoryProtocol.self, service: ContentRepository())
        
        DIContainer.shared.register(type: GetContentUseCase.self, service: GetContentUseCase())
        DIContainer.shared.register(type: SaveContentUseCase.self, service: SaveContentUseCase())
        DIContainer.shared.register(type: DeleteContentUseCase.self, service: DeleteContentUseCase())
        DIContainer.shared.register(type: SearchContentUseCase.self, service: SearchContentUseCase())
        DIContainer.shared.register(type: FetchDownloadContentUseCase.self, service: FetchDownloadContentUseCase())
    }
    
    private func registerYoutubeDependencies() {
        DIContainer.shared.register(type: YoutubeRepositoryProtocol.self, service: YoutubeRepository())
        
        DIContainer.shared.register(type: SearchYoutubeUseCase.self, service: SearchYoutubeUseCase())
    }
    
    private func registerViewModel() {
        DIContainer.shared.register(type: HomeViewModel.self, service: HomeViewModel())
        DIContainer.shared.register(type: UpcommingViewModel.self, service: UpcommingViewModel())
        DIContainer.shared.register(type: SearchViewModel.self, service: SearchViewModel())
        DIContainer.shared.register(type: DownloadViewModel.self, service: DownloadViewModel())
        DIContainer.shared.register(type: VideoPreviewViewModel.self, service: VideoPreviewViewModel())
    }
}
