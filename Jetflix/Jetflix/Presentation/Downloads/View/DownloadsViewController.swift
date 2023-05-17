//
//  DownloadsViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit
import Combine

class DownloadsViewController: UIViewController {

    //MARK: - Views
    private let downloadTable: UITableView = {
        let table = UITableView()
        table.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.identifier)
        return table
    }()
    
    //MARK: - Properties
    private var viewModel = DownloadViewModel(fetchDownloadContentUseCase: .init(repository: ContentRepository()),
                                              deleteContentUseCase: .init(repository: ContentRepository()))
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
        
        downloadTable.delegate = self
        downloadTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDownloadsContents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
    private func bind() {
        viewModel.$contents
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloads in
                self?.downloadTable.reloadData()
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadTable)
    }
    
    private func fetchDownloadsContents() {
        viewModel.action(.fetchDownloadContents)
    }
}

//MARK: - UITableViewDelegate
extension DownloadsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.contents[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let content = viewModel.contents[indexPath.row]
        
        let videoPreviewVC = VideoPreviewViewController()
        videoPreviewVC.content = content
        navigationController?.present(videoPreviewVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            viewModel.action(.delete(indexPath.row))
        default: break
        }
    }
}

//MARK: - UITableViewDataSource
extension DownloadsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contents.count
    }
}
