//
//  GFRepoItemVC.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/17/24.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems()
    }
    
    private func configureItems() {
        itemInfoView1.set(itemInfoType: .repos, with: user.publicRepos)
        itemInfoView2.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }

    override func didTapActionButton() {
        delegate.didTapGithubProfile(for: user)
    }
}
