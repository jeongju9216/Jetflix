//
//  UpcomingViewController.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/13.
//

import UIKit

class UpcomingViewController: UIViewController {

    //MARK: - Views
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.identifier)
        return table
    }()
    
    //MARK: - Properties
    var contents: [Content] = []
    let repository = ContentRepository()
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingTable.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    //MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.addSubview(upcomingTable)
    }
    
    private func fetchUpcoming() {
        Task {
            do {
                contents = try await repository.getContents(type: .upcoming)
                upcomingTable.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension UpcomingViewController: UITableViewDelegate {
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
        
        let movie = contents[indexPath.row]
        
        let videoPreviewVC = VideoPreviewViewController()
        videoPreviewVC.content = movie
        navigationController?.present(videoPreviewVC, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension UpcomingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
}
