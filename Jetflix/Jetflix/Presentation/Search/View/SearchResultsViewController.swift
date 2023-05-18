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
    let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 5, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ContentPosterCollectionViewCell.self, forCellWithReuseIdentifier: ContentPosterCollectionViewCell.identifier)
        
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
    
    func clearData() {
        contents.removeAll()
        DispatchQueue.main.async { [weak self] in
            self?.searchResultsCollectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDelegate
extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentPosterCollectionViewCell.identifier, for: indexPath) as? ContentPosterCollectionViewCell else {
            return UICollectionViewCell()
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
