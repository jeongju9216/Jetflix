//
//  SearchResultsViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/14.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ content: Content)
}

class SearchResultsViewController: UIViewController {

    //MARK: - Views
    lazy var searchResultsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createGridCompositionalLayout())
        collectionView.register(ContentPosterCollectionViewCell.self, forCellWithReuseIdentifier: ContentPosterCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: DefaultCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DefaultCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    //MARK: - Properties
    var contents: [Content] = []
    weak var delegate: SearchResultsViewControllerDelegate?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsCollectionView.frame = view.bounds
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchResultsCollectionView)
    }
    
    //MARK: - Methods
    func clearData() {
        contents.removeAll()
        DispatchQueue.main.async { [weak self] in
            self?.searchResultsCollectionView.reloadData()
        }
    }

    func createGridCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3), heightDimension: .absolute(200))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        
        return layout
    }
}

//MARK: - UICollectionViewDelegate
extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCollectionViewCell.identifier, for: indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentPosterCollectionViewCell.identifier, for: indexPath) as? ContentPosterCollectionViewCell else {
            return defaultCell
        }
        
        cell.configure(with: contents[indexPath.row].posterURLString ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        delegate?.searchResultsViewControllerDidTapItem(contents[indexPath.row])
    }
}

//MARK: - UICollectionViewDataSource
extension SearchResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
}
