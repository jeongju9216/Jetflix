//
//  HomeViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    enum Sections: Int, CaseIterable {
        case header, TrendingMovies, TrendingTv, Popular, Upcoming, TopRated
        
        var title: String {
            switch self {
            case .header: return ""
            case .TrendingMovies: return "Trending Movies"
            case .TrendingTv: return "Trending TV"
            case .Popular: return "Popular"
            case .Upcoming: return "Upcoming Movies"
            case .TopRated: return "Top rated"
            }
        }
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Sections, Content>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Sections, Content>

    //MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
        collectionView.register(ContentPosterCollectionViewCell.self, forCellWithReuseIdentifier: ContentPosterCollectionViewCell.identifier)
        collectionView.register(PosterHeaderCollectionViewCell.self, forCellWithReuseIdentifier: PosterHeaderCollectionViewCell.identifier)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.identifier)
        collectionView.register(UINib(nibName: DefaultCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DefaultCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    //MARK: - Properties
    private lazy var dataSource: DataSource = setupDataSource()
    private var snapshot: SnapShot = SnapShot()
    @Dependency private var viewModel: HomeViewModel
    private var cancellable: Set<AnyCancellable> = []
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        bind()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    private func bind() {
        viewModel.$randomTrendingContent
            .receive(on: RunLoop.main)
            .sink { [weak self] randomContent in
                guard let self = self, let randomContent = randomContent else { return }
                
                self.snapshot.appendItems([randomContent], toSection: .header)
            }
            .store(in: &cancellable)
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
                
        configurationNavbar()
    }
    
    private func setupDataSource() -> DataSource {
        let cellProvider = { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, product: Content) -> UICollectionViewCell? in
            let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCollectionViewCell.identifier, for: indexPath)
            
            switch Sections(rawValue: indexPath.section) {
            case .header:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterHeaderCollectionViewCell.identifier, for: indexPath) as? PosterHeaderCollectionViewCell else {
                    return defaultCell
                }
                
                cell.configure(with: product)
                
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentPosterCollectionViewCell.identifier, for: indexPath) as? ContentPosterCollectionViewCell else {
                    return defaultCell
                }
                
                cell.configure(with: product.posterURLString ?? "")
                
                return cell
            }
        }

        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        dataSource.supplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            
            let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCollectionViewCell.identifier, for: indexPath)
            
            guard let self = self, elementKind == UICollectionView.elementKindSectionHeader else {
                return defaultCell
            }

            guard let headView = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView else {
                return defaultCell
            }

            headView.configuration(Sections(rawValue: indexPath.section)?.title ?? "")

            return headView
        }
        
        return dataSource
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            switch Sections(rawValue: sectionIndex) {
            case .header:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(UIScreen.main.bounds.height * 0.65))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(150),
                                                      heightDimension: .absolute(220))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                let sectionInset = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10)
                section.contentInsets = sectionInset
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(30))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            }
        }
        
        return layout
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
    
    //MARK: - Methods
    private func fetchData() {
        Task {
            snapshot.appendSections(Sections.allCases)
            
            var contentType: ContentType = .trending(.movie)
            for section in Sections.allCases {
                switch section {
                case .header: break
                case .TrendingMovies:
                    contentType = .trending(.movie)
                case .TrendingTv:
                    contentType = .trending(.tv)
                case .Popular:
                    contentType = .popular
                case .Upcoming:
                    contentType = .upcoming
                case .TopRated:
                    contentType = .topRated
                }
                
                if section != .header {
                    let contents = try? await viewModel.action(.getContents(contentType)).value as? [Content]
                    snapshot.appendItems(contents ?? [], toSection: section)
                } else {
                    try? await viewModel.action(.getRandomTrendingContent)
                }
            }
            
            await dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let content = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let videoPreviewVC = VideoPreviewViewController()
        videoPreviewVC.content = content
        navigationController?.present(videoPreviewVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ContentPosterCollectionViewCell else { return }
        
        cell.cancelDownloadImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let firstIndexPath = indexPaths.first,
              let content = self.dataSource.itemIdentifier(for: firstIndexPath) else { return nil }
        
        //포스터 헤더는 롱클릭 지원 안 함
        if Sections(rawValue: firstIndexPath.section) == .header {
            return nil
        }
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download", state: .off) { _ in
                Task {
                    try? await self?.viewModel.action(.save(content))
                }
            }
            
            return UIMenu(options: .displayInline, children: [downloadAction])
        }
        
        return config
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        //아래로 스크롤을 하면 네비게이션바가 함께 올라가도록 구현
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
