//
//  UITabBarController Extension.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/11/24.
//
import UIKit

extension UITabBarController {
    static func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor : UIColor.secondaryLabel,
            .font : UIFont.systemFont(ofSize: 12)
        ]
        
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor : UIColor.defaultGreenColor,
            .font : UIFont.boldSystemFont(ofSize: 12)
        ]
        
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.defaultGreenColor
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
