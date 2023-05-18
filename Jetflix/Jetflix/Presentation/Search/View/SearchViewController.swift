//
//  SearchViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit
import Combine

class SearchViewController: UIViewController, ContentListCollectionViewProtocol {
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

    private let searchController: UISearchController = {
        let searchResultsVC = SearchResultsViewController()
        let controller = UISearchController(searchResultsController: searchResultsVC)
        
        controller.searchBar.placeholder = "Search for a Movie"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()
    
    //MARK: - Properties
    private lazy var dataSource: DataSource = setupDataSource()
    private var snapshot: SnapShot = SnapShot()
    private var viewModel = SearchViewModel(getContentUseCase: .init(repository: ContentRepository()),
                                            searchContentUseCase: .init(repository: ContentRepository()),
                                            saveContentUseCase: .init(repository: ContentRepository()))
    private var cancellables: Set<AnyCancellable> = []
    private var textInputTimerCancellable: Cancellable?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        fetchDiscoverData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
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
        
        viewModel.$searchResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchResult in
                guard let self = self,
                      let resultsController = self.searchController.searchResultsController as? SearchResultsViewController else {
                    return
                }
                
                resultsController.delegate = self
                resultsController.contents = searchResult
                resultsController.searchResultsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        title = "Top Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
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
        snapshot.appendSections([Sections.main])
        
        return dataSource
    }

    //MARK: - Methods
    private func fetchDiscoverData() {
        Task {
            viewModel.action(.fetchContents)
        }
    }
    
    private func search(with query: String) {
        cancelTextInputTimer()
        
        textInputTimerCancellable = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                print("Search: \(query)")
                self.viewModel.action(.search(query))
            }
    }
    
    private func cancelSearch() {
        cancelTextInputTimer()
        (searchController.searchResultsController as? SearchResultsViewController)?.clearData()
    }
    
    private func presentVideoPreivewWith(content: Content) {
        let videoPreviewVC = VideoPreviewViewController()
        videoPreviewVC.content = content
        navigationController?.present(videoPreviewVC, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let content = dataSource.itemIdentifier(for: indexPath) else { return }
            
        presentVideoPreivewWith(content: content)
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


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            cancelSearch()
            return
        }
        
        search(with: query)
    }
}

//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            cancelSearch()
            return
        }
        
        search(with: query)
    }
    
    private func cancelTextInputTimer() {
        textInputTimerCancellable?.cancel()
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ content: Content) {
        presentVideoPreivewWith(content: content)
    }
}
