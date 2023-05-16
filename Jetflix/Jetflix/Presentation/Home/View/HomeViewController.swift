//
//  HomeViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit

enum Sections: Int {
    case TrendingMovies
    case TrendingTv
    case Popular
    case Upcoming
    case TopRated
}

class HomeViewController: UIViewController {

    //MARK: - Views
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return tableView
    }()
    
    private var headerView: PosterHeaderUIView?
    
    //MARK: - Properties
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top rated"]
    private let repository = ContentRepository()
    private var randomTrendingMovie: Content?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTable.frame = view.bounds
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        configurationNavbar()
        
        headerView = PosterHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.65))
        configurePosterHeaderView()
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func configurationNavbar() {
        var image = UIImage(named: "LogoImage")
        //iOS 시스템에서 색상을 변경하는 것을 막고, 항상 이미지 본연의 색상으로 출력하게 함
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let logoItem = UIButton(type: .custom)
        logoItem.frame = CGRect(x: 0.0, y: 0.0, width: 32, height: 32)
        logoItem.setImage(image, for: .normal)

        let leftItem = UIBarButtonItem(customView: logoItem)
        leftItem.customView?.widthAnchor.constraint(equalToConstant: 32).isActive = true
        leftItem.customView?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
        ]
        
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configurePosterHeaderView() {
        Task {
            guard let movies = try? await repository.getContents(type: .trending(.movie)),
                  let randomTrendingMovie = movies.randomElement() else { return }
            
            self.randomTrendingMovie = randomTrendingMovie
            headerView?.configure(with: randomTrendingMovie)
        }
    }
}

//MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
                
        Task {
            let apiType: APIType
            switch indexPath.section {
            case Sections.TrendingMovies.rawValue:
                apiType = .trending(.movie)
            case Sections.TrendingTv.rawValue:
                apiType = .trending(.tv)
            case Sections.Popular.rawValue:
                apiType = .popular
            case Sections.Upcoming.rawValue:
                apiType = .upcoming
            case Sections.TopRated.rawValue:
                apiType = .topRated
            default: return
            }

            let contents = try? await repository.getContents(type: apiType)
            cell.configure(with: contents ?? [])
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        //아래로 스크롤을 하면 네비게이션바가 함께 올라가도록 구현
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

//MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
}

//MARK: - CollectionViewTableViewCellDelegate
extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, content: Content) {
        let videoPreviewVC = VideoPreviewViewController()
        videoPreviewVC.content = content
        navigationController?.present(videoPreviewVC, animated: true)
    }
    
    func collectionViewTableViewCellDidClickDownload(content: Content) {
        Task {
            do {
                try await repository.saveWith(content: content)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
