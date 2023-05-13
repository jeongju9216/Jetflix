//
//  MainTabBarViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/12.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.title = "Home"
        
        let upcomingVC = UINavigationController(rootViewController: UpcomingViewController())
        upcomingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        upcomingVC.title = "Coming Soon"
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchVC.title = "Top Search"
        
        let downloadVC = UINavigationController(rootViewController: DownloadsViewController())
        downloadVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        downloadVC.title = "Downloads"
        
        tabBar.tintColor = .label
        
        setViewControllers([homeVC, upcomingVC, searchVC, downloadVC], animated: false)
    }
}

