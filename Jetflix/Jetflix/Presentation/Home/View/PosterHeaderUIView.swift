//
//  PosterHeaderUIView.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit

class PosterHeaderUIView: UIView {

    //MARK: - Views
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "PosterImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
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
    private func applayConstraints() {
        let playButtonConstraints = [
            playButton.widthAnchor.constraint(equalToConstant: bounds.width * 0.42),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.widthAnchor.constraint(equalToConstant: bounds.width * 0.42),
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
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
