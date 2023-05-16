//
//  SearchViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    //MARK: - Views
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.identifier)
        return table
    }()

    private let searchController: UISearchController = {
        let searchResultsVC = SearchResultsViewController()
        let controller = UISearchController(searchResultsController: searchResultsVC)
        
        controller.searchBar.placeholder = "Search for a Movie"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()
    
    //MARK: - Properties
    private var viewModel = SearchViewModel(contentRepository: ContentRepository())
    private var cancellables: Set<AnyCancellable> = []
    private var textInputTimerCancellable: Cancellable?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        fetchDiscoverData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        discoverTable.frame = view.bounds
    }
    
    private func bind() {
        viewModel.$contents
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contents in
                self?.discoverTable.reloadData()
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
    
    //MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        
        title = "Top Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
    }
    
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
    
    private func presentVideoPreivewWith(content: Content) {
        let videoPreviewVC = VideoPreviewViewController()
        videoPreviewVC.content = content
        navigationController?.present(videoPreviewVC, animated: true)
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.contents[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presentVideoPreivewWith(content: viewModel.contents[indexPath.row])
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contents.count
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty else {
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
