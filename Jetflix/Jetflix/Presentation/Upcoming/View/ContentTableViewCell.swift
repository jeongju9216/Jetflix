//
//  ContentTableViewCell.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/14.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    static let identifier = "ContentTableViewCell"
    
    //MARK: - Views
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let playImage = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
        button.setImage(playImage, for: .normal)
        button.tintColor = .label
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 2
        
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Methods
    private func applyConstraints() {
        let posterImageViewConstraints = [
            posterImageView.widthAnchor.constraint(equalToConstant: 60),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ]
        
        let playButtonConstraints = [
            playButton.widthAnchor.constraint(equalToConstant: 40),
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -15),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    func configure(with content: Movie) {
        guard let posterURL = content.posterURL,
                let url = URL(string: posterURL) else { return }
        
        posterImageView.kf.setImage(with: url)
        titleLabel.text = content.displayTitle
    }
}
