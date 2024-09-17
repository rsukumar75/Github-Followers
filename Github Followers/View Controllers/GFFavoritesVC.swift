//
//  FavoritesVC.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/11/24.
//

import UIKit
import SwiftUI

class GFFavoritesVC: UIViewController {
    enum Section {
        case main
    }
    
    var favorites: [Follower] = []
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getFavorites()
    }
    
    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func getFavorites() {
        showLoadingView()
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let favorites):
                self.favorites = favorites
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case.failure(let error):
                self.presentGFAlertOnMainThread(alertTitle: "Failed to fetch favorites", message: error.rawValue , buttonTitle: "OK")
            }
        }
    }
    
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(GFFavoritesCell.self, forCellReuseIdentifier: GFFavoritesCell.reuseId)
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
}

extension GFFavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GFFavoritesCell.reuseId, for: indexPath) as! GFFavoritesCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let favorite = favorites[indexPath.row]
        let followerListVC = GFFollowerListVC(username: favorite.login)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
}
