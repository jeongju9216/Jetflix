//
//  DownloadsViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit

class DownloadsViewController: UIViewController {

    //MARK: - Views
    private let downloadTable: UITableView = {
        let table = UITableView()
        table.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.identifier)
        return table
    }()
    
    //MARK: - Properties
    private var contents: [Content] = []
    private let repository = ContentRepository()
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
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
    
    //MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadTable)
    }
    
    private func fetchDownloadsContents() {
        Task {
            do {
                contents = try await repository.fetchDownloadsContents()
                downloadTable.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension DownloadsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: contents[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let content = contents[indexPath.row]
        
        let videoPreviewVC = VideoPreviewViewController()
        videoPreviewVC.content = content
        navigationController?.present(videoPreviewVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            Task {
                do {
                    let content = contents[indexPath.row]
                    try await repository.delete(content: content)
                    
                    contents.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch {
                    print(error.localizedDescription)
                }
            }
        default: break
        }
    }
}

//MARK: - UITableViewDataSource
extension DownloadsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
}
