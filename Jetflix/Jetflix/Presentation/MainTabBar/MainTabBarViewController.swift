//
//  MainTabBarViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/12.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    typealias TabItem = (vc: UINavigationController, title: String, icon: String)
    
    private let tabItems: [TabItem] = [
        (UINavigationController(rootViewController: HomeViewController()), "Home", "house"),
        (UINavigationController(rootViewController: UpcomingViewController()), "Upcoming", "play.circle"),
        (UINavigationController(rootViewController: SearchViewController()), "Top Search", "magnifyingglass"),
        (UINavigationController(rootViewController: DownloadsViewController()), "Downloads", "arrow.down.to.line")
    ]
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configurationViewControllers()
        
        delegate = self
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .label
    }
    
    private func configurationViewControllers() {
        tabItems.forEach {
            $0.vc.title = $0.title
            $0.vc.tabBarItem.image = UIImage(systemName: $0.icon)
        }

        setViewControllers(tabItems.map { $0.vc }, animated: false)
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    //true: 화면 전환, false: 화면 전환 필요 없음
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let currentIndex = tabBarController.selectedIndex
        let currentVC = tabBarController.viewControllers?[currentIndex]
        
        guard currentVC == viewController else {
            //현재 VC와 선택한 탭의 VC가 다르면 화면을 전환
            return true
        }
        
        //현재 탭을 선택하면 맨 위 Rect 위치로 scroll함
        let rootVC = tabItems[currentIndex].vc.viewControllers.last
        let scrollView = rootVC?.view.subviews.first { $0 is UIScrollView } as? UIScrollView
        scrollView?.scrollRectToVisible(CGRect(origin: .zero, size: CGSize(width: 1, height: 1)), animated: true)

        return false
    }
}
