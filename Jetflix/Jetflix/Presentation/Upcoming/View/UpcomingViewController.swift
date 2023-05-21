//
//  UpcomingViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit
import Combine


class UpcomingViewController: UIViewController, ContentListCollectionViewProtocol {
    enum Sections: Int {
        case main
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Sections, Content>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Sections, Content>
    
    //MARK: - Views
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createVerticalCompositionalLayout(
                                                itemSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                heightDimension: .absolute(150)),
                                                itemInsets: .init(top: 5, leading: 0, bottom: 5, trailing: 0)))
        
        collectionView.register(ContentListCollectionViewCell.self, forCellWithReuseIdentifier: ContentListCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: DefaultCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DefaultCollectionViewCell.identifier)
        
        return collectionView
    }()

    //MARK: - Properties
    private lazy var dataSource: DataSource = setupDataSource()
    private var snapshot: SnapShot = SnapShot()
    private var viewModel = UpcommingViewModel(getContentUseCase: .init(repository: ContentRepository()),
                                               saveContentUseCase: .init(repository: ContentRepository()))
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
                
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        bind()
        fetchUpcomingContents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    private func bind() {
        viewModel.$contents
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contents in
                guard let self = self else { return }
                
                if !contents.isEmpty {
                    self.snapshot.appendItems(contents, toSection: .main)
                    dataSource.apply(self.snapshot, animatingDifferences: false)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.addSubview(collectionView)
    }
    
    private func setupDataSource() -> DataSource {
        let cellProvider = { (collectionView: UICollectionView, indexPath: IndexPath, product: Content) -> UICollectionViewCell? in
            let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCollectionViewCell.identifier, for: indexPath)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentListCollectionViewCell.identifier, for: indexPath) as? ContentListCollectionViewCell else {
                return defaultCell
            }
            
            cell.configure(with: product)
            
            return cell
        }

        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        snapshot.appendSections([Sections.main])
        
        return dataSource
    }
    
    //MARK: - Methods
    private func fetchUpcomingContents() {
        viewModel.action(.fetchContents)
    }
}

extension UpcomingViewController: UICollectionViewDelegate {
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
}
