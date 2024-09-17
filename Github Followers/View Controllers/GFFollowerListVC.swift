//
//  FollowerListVC.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/13/24.
//

import UIKit

class GFFollowerListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    let searchPlaceholder = "Search for a username"
    var isSearching = false
    var username: String
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var pageNumber: Int = 1
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var hasMoreFollowers = true
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupSearchController()
        setupCollectionView()
        setupDataSource()
        getFollowers()
    }
    
    func setupViewController() {
        view.backgroundColor = .systemBackground
        title = username
        navigationController?.navigationBar.prefersLargeTitles = true
        let addFavoriteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToFavorites))
        navigationItem.rightBarButtonItem = addFavoriteButton
    }
    
    @objc func addToFavorites() {
        showLoadingView()
        NetworkManager.sharedInstance.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: self.username, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        self.presentGFAlertOnMainThread(alertTitle: "Could not add to favorites", message: error.rawValue, buttonTitle: "OK")
                    } else {
                        self.presentGFAlertOnMainThread(alertTitle: "Success", message: "Successfully added \(self.username) to favorites 🎉", buttonTitle: "OK")
                    }
                }
                break
            case .failure(let error):
                self.presentGFAlertOnMainThread(alertTitle: "Unable to get user info", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func setupSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = searchPlaceholder
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.getThreeColumnFlowLayout(view: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GFFollowerCell.self, forCellWithReuseIdentifier: GFFollowerCell.reuseID)
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.delegate = self
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GFFollowerCell.reuseID, for: indexPath) as! GFFollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func getFollowers() {
        showLoadingView()
        NetworkManager.sharedInstance.getFollowers(for: username, page: pageNumber) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                if (followers.count < NetworkManager.sharedInstance.pageSize) {
                    self.hasMoreFollowers = false
                }
                
                self.followers.append(contentsOf: followers)
                
                if (self.followers.isEmpty) {
                    let emptyMessage = "This user doesn't have any followers. Go follow them 😁"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: emptyMessage, in: self.view)
                    }
                    return
                }
                
                self.updateData(followers: self.followers)
            case .failure(let gfError):
                self.presentGFAlertOnMainThread(alertTitle: "Unable to fetch followers", message: gfError.rawValue, buttonTitle: "OK")
                return
            }
        }
    }
    
    func updateData(followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers, toSection: .main)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension GFFollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            
            pageNumber += 1
            getFollowers()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeFollowersArray = isSearching ? filteredFollowers : followers
        let follower = activeFollowersArray[indexPath.item]
        let userInfoVC = GFUserInfoVC(username: follower.login)
        userInfoVC.delegate = self
        let userInfoNC = UINavigationController(rootViewController: userInfoVC)
        
        present(userInfoNC, animated: true)
    }
}

extension GFFollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        // Filter is the text and should not be empty
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            updateData(followers: followers)
            return
        }
        
        isSearching = true
        
        filteredFollowers = followers.filter { $0.login.lowercased().hasPrefix(filter.lowercased()) }
        
        updateData(followers: filteredFollowers)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(followers: followers)
        
        isSearching = false
    }
}

extension GFFollowerListVC: GFUserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        followers.removeAll()
        filteredFollowers.removeAll()
        pageNumber = 1
        hasMoreFollowers = true
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers()
    }
}
