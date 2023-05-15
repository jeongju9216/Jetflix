//
//  ContentCollectionViewCell.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/14.
//

import UIKit
import Kingfisher

class ContentCollectionViewCell: UICollectionViewCell {
    static let identifier = "ContentCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        posterImageView.frame = contentView.bounds
    }
    
    func configure(with urlString: String) {
//        print("\(#function) urlString: \(urlString)")
//        posterImageView.setImageUsingJIC(url: "https://image.tmdb.org/t/p/w500" + urlString)
        guard let url = URL(string: urlString) else { return }
        
        posterImageView.kf.setImage(with: url)
    }
}
