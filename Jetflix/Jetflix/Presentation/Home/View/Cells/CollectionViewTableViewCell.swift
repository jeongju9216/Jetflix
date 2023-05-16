//
//  CollectionViewTableViewCell.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, content: Content)
    func collectionViewTableViewCellDidClickDownload(content: Content)
}

class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var contents: [Content] = []
    
    //MARK: - Views
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    //MARK: - Methods
    func configure(with contents: [Content]) {
        self.contents = contents
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        delegate?.collectionViewTableViewCellDidClickDownload(content: contents[indexPath.row])
    }
}

//MARK: - UICollectionViewDelegate
extension CollectionViewTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as? ContentCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let posterURLString = contents[indexPath.row].posterURLString else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: posterURLString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ContentCollectionViewCell else { return }
        
        cell.cancelDownloadImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let content = contents[indexPath.row]
        delegate?.collectionViewTableViewCellDidTapCell(self, content: content)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                let downloadAction = UIAction(title: "Download", state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPaths[0])
                }
                return UIMenu(options: .displayInline, children: [downloadAction])
            }
        
        return config
    }
}

//MARK: - UICollectionViewDataSource
extension CollectionViewTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
}
