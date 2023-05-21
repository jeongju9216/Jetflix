//
//  PosterHeaderCollectionViewCell.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/18.
//

import UIKit

class PosterHeaderCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Views
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .top
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
                
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Play", for: .normal)
        
        button.clipsToBounds = false
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Download", for: .normal)
        
        button.clipsToBounds = false
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        
        return button
    }()

    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(posterImageView)
        addGradient()
        addSubview(titleLabel)
        
        addSubview(playButton)
        addSubview(downloadButton)
        
        applayConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = bounds
    }
    
    //MARK: - Methods
    func configure(with content: Content) {
        guard let posterURLString = content.posterURLString,
              let url = URL(string: posterURLString) else {
            posterImageView.image = UIImage(named: "PosterImage")
            return
        }
        
        posterImageView.kf.setImage(with: url)
        titleLabel.text = content.displayTitle
    }
    
    private func applayConstraints() {
        let playButtonConstraints = [
            playButton.widthAnchor.constraint(equalToConstant: bounds.width * 0.42),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.widthAnchor.constraint(equalToConstant: bounds.width * 0.42),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ]
        
        let titleLabelConstraints = [
            titleLabel.widthAnchor.constraint(equalToConstant: bounds.width * 0.8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -20),
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        
        layer.addSublayer(gradientLayer)
    }
}
