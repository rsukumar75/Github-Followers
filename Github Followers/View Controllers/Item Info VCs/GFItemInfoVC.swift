//
//  ItemInfoVC.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/16/24.
//

import UIKit

protocol GFItemInfoVCDelegate: AnyObject {
    func didTapGithubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class GFItemInfoVC: UIViewController {
    let itemStackView = UIStackView()
    let itemInfoView1 = GFItemInfoView()
    let itemInfoView2 = GFItemInfoView()
    let actionButton = GFButton()
    let user: User!
    
    weak var delegate: GFItemInfoVCDelegate!
    
    init(user: User!) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        setupActionButton()
        layoutUI()
        setupStackView()
    }
    
    private func setupViewController() {
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 18
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        view.addSubview(itemStackView)
        view.addSubview(actionButton)
        
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itemStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            itemStackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: itemStackView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: itemStackView.trailingAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupStackView() {
        itemStackView.axis = .horizontal
        itemStackView.distribution = .equalSpacing
        
        itemStackView.addArrangedSubview(itemInfoView1)
        itemStackView.addArrangedSubview(itemInfoView2)
    }
    
    private func setupActionButton() {
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    @objc func didTapActionButton() {}
}
