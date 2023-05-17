//
//  HomeViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit
import Combine

enum Sections: Int {
    case TrendingMovies
    case TrendingTv
    case Popular
    case Upcoming
    case TopRated
}

class HomeViewController: UIViewController {

    //MARK: - Views
    private var headerView: PosterHeaderUIView = {
        let headerView = PosterHeaderUIView(frame: CGRect(x: 0, y: 0,
                                                          width: UIScreen.main.bounds.width,
                                                          height: UIScreen.main.bounds.height * 0.65))
        return headerView
    }()
    
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return tableView
    }()
    
    
    //MARK: - Properties
    private let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top rated"]
    private let viewModel = HomeViewModel(getContentUseCase: .init(repository: ContentRepository()),
                                          saveContentUseCase: .init(repository: ContentRepository()))
    private var cancellable: Set<AnyCancellable> = []
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTable.frame = view.bounds
    }
    
    private func bind() {
        viewModel.$randomTrendingContent
            .receive(on: RunLoop.main)
            .sink { [weak self] randomContent in
                guard let randomContent = randomContent else { return }
                
                self?.headerView.configure(with: randomContent)
            }
            .store(in: &cancellable)
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        homeFeedTable.tableHeaderView = headerView
        view.addSubview(homeFeedTable)
        Task {
            do {
                try await viewModel.action(.getRandomTrendingContent)
            } catch {
                //todo: 기본 이미지 추가해서 에러 핸들링
            }
        }
        
        configurationNavbar()
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
}

//MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
                
        Task {
            let contentType: ContentType
            switch indexPath.section {
            case Sections.TrendingMovies.rawValue:
                contentType = .trending(.movie)
            case Sections.TrendingTv.rawValue:
                contentType = .trending(.tv)
            case Sections.Popular.rawValue:
                contentType = .popular
            case Sections.Upcoming.rawValue:
                contentType = .upcoming
            case Sections.TopRated.rawValue:
                contentType = .topRated
            default: return
            }

            let contents = try? await viewModel.action(.getContents(contentType)).value as? [Content]
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
            try? await viewModel.action(.save(content))
        }
    }
}
