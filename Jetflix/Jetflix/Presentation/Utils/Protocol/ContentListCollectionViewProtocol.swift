//
//  ContentListCollectionViewProtocol.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/18.
//

import UIKit

protocol ContentListCollectionViewProtocol {
    var collectionView: UICollectionView { get set }
}

extension ContentListCollectionViewProtocol {
    func createVerticalCompositionalLayout(itemSize: NSCollectionLayoutSize, itemInsets: NSDirectionalEdgeInsets) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = itemInsets
        
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        
        return layout
    }
}
