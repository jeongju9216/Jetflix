//
//  TitlePreviewViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/14.
//

import UIKit
import WebKit
import Combine

class VideoPreviewViewController: UIViewController {
    
    //MARK: - Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = UIColor(named: "MainRed")
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
       
       return button
   }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    
    //MARK: - Properties
    private var viewModel = VideoPreviewViewModel(searchYoutubeUseCase: .init(repository: YoutubeRepository()))
    var content: Content?
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
        
        fetchTrailerMovie()
    }
    
    private func bind() {
        viewModel.$trailerVideoElement
            .receive(on: DispatchQueue.main)
            .sink { [weak self] trailerVideoElement in
                guard let self = self,
                      let content = self.content,
                      let trailerVideoElement = trailerVideoElement else { return }
                
                let videoPreview = VideoPreview(title: content.displayTitle,
                                                youtubeView: trailerVideoElement,
                                                titleOverview: content.displayOverView)
                configure(with: videoPreview)
            }
            .store(in: &cancellables)
    }
 
    //MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        configureConstraints()
    }
    
    private func configureConstraints() {
        let webViewConstraints = [
            webView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 9 / 16),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    private func fetchTrailerMovie() {
        guard let content = content else { return }
        
        viewModel.action(.getMovieTrailer(content.displayTitle))
    }
    
    private func configure(with model: VideoPreview) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
}
