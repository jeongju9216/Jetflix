//
//  DownloadsViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit
import Combine

class DownloadsViewController: UIViewController, ContentListCollectionViewProtocol {

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
        
        return collectionView
    }()
    
    //MARK: - Properties
    private lazy var dataSource: DataSource = setupDataSource()
    private var snapshot: SnapShot = SnapShot()
    private var viewModel = DownloadViewModel(fetchDownloadContentUseCase: .init(repository: ContentRepository()),
                                              deleteContentUseCase: .init(repository: ContentRepository()))
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDownloadsContents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func bind() {
        viewModel.$contents
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloads in
                guard let self = self else { return }
                
                if !downloads.isEmpty {
                    self.snapshot = SnapShot()
                    self.snapshot.appendSections([.main])
                    self.snapshot.appendItems(downloads, toSection: .main)
                    dataSource.apply(self.snapshot, animatingDifferences: true)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(collectionView)
    }
    
    private func setupDataSource() -> DataSource {
        let cellProvider = { (collectionView: UICollectionView, indexPath: IndexPath, product: Content) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentListCollectionViewCell.identifier, for: indexPath) as? ContentListCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: product)
            
            return cell
        }

        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        
        return dataSource
    }
    
    private func fetchDownloadsContents() {
        viewModel.action(.fetchDownloadContents)
    }
}

//MARK: - UICollectionViewDelegate
extension DownloadsViewController: UICollectionViewDelegate {
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
            let deleteAction = UIAction(title: "Delete", state: .off) { _ in
                self?.viewModel.action(.delete(firstIndexPath.row))
            }
            
            return UIMenu(options: .displayInline, children: [deleteAction])
        }
        
        return config
    }
}
