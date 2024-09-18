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
        Task {
            do {
                favorites = try await PersistenceManager.retrieveFavorites()
                updateFavorites(with: favorites)
                dismissLoadingView()
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(alertTitle: "Failed to fetch favorites", message: gfError.rawValue, buttonTitle: "OK")
                } else {
                    presentGFAlert()
                }
                
                dismissLoadingView()
            }
        }
    }
    
    private func updateFavorites(with favorites: [Follower]) {
        if favorites.isEmpty {
            showEmptyStateView(with: "No Favorites?\nAdd one in the followers screen.", in: self.view)
        } else {
            tableView.reloadData()
            view.bringSubviewToFront(self.tableView)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toRemove = favorites[indexPath.row]
            
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            Task {
                do {
                    try await PersistenceManager.updateWith(favorite: toRemove, actionType: .remove)
                } catch {
                    if let gfError = error as? GFError {
                        presentGFAlert(alertTitle: "Unable to delete", message: gfError.rawValue, buttonTitle: "OK")
                    } else {
                        presentGFAlert()
                    }
                }
                
                getFavorites()
            }
        }
    }
}
