//
//  GFTabBarControllerViewController.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/17/24.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarController()
    }
    
    private func setupTabBarController() {
        UITabBarController.setupTabBarAppearance()
        viewControllers = [self.createSearchNC(), self.createFavoritesNC()]
        selectedIndex = 0
    }
    
    private func createSearchNC() -> UINavigationController {
        let searchVC = GFSearchUserVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let searchNav = UINavigationController(rootViewController: searchVC)
        
        return searchNav
    }
    
    private func createFavoritesNC() -> UINavigationController {
        let favoritesVC = GFFavoritesVC()
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        
        return favoritesNav
    }


}
