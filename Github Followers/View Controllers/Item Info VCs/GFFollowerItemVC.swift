//
//  GFFollowerItemVC.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/17/24.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems()
    }
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .followers, with: user.followers)
        itemInfoView2.set(itemInfoType: .following, with: user.following)
        actionButton.set(backgroundColor: .defaultGreenColor, title: "Get Followers")
    }

    override func didTapActionButton() {
        delegate.didTapGetFollowers(for: user)
    }
}
