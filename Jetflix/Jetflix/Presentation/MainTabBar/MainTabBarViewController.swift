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
        
        setupUI()
        configurationViewControllers()
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .label
    }
    
    private func configurationViewControllers() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.title = "Home"
        
        let upcomingVC = UINavigationController(rootViewController: UpcomingViewController())
        upcomingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        upcomingVC.title = "Upcoming"
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchVC.title = "Top Search"
        
        let downloadVC = UINavigationController(rootViewController: DownloadsViewController())
        downloadVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        downloadVC.title = "Downloads"

        setViewControllers([homeVC, upcomingVC, searchVC, downloadVC], animated: false)
    }
}

