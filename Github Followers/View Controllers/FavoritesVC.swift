//
//  FavoritesVC.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/11/24.
//

import UIKit
import SwiftUI

class FavoritesVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        let dummyGridVC = UIHostingController(rootView: DummyGridView())
        dummyGridVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dummyGridVC.view)
        
        let leadingConstraint = dummyGridVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = dummyGridVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let topConstraint = dummyGridVC.view.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomConstraint = dummyGridVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
}
