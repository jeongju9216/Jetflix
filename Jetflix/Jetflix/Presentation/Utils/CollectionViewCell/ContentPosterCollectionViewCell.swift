//
//  ContentPosterCollectionViewCell.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/14.
//

import UIKit
import Kingfisher

class ContentPosterCollectionViewCell: UICollectionViewCell {
    static let identifier = "ContentCollectionViewCell"
    
    //MARK: - Views
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        
        return imageView
    }()
    
    //MARK: - Init
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
    
    //MARK: - Methods
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        posterImageView.kf.setImage(with: url)
    }
    
    func cancelDownloadImage() {
        posterImageView.kf.cancelDownloadTask()
    }
}
