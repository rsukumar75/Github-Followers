//
//  UserInfoVC.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/15/24.
//

import UIKit

protocol GFUserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class GFUserInfoVC: UIViewController {
    let username: String
    let headerView = UIView()
    let itemView1 = UIView()
    let itemView2 = UIView()
    var itemViews: [UIView] = []
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    weak var delegate: GFUserInfoVCDelegate!
    
    init(username: String) {
        self.username = username
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        setupNavBarItems()
        layoutUI()
        getUserInfo()
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        let height: CGFloat = 140
        itemViews = [headerView, itemView1, itemView2, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemView1.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemView1.heightAnchor.constraint(equalToConstant: height),
            
            itemView2.topAnchor.constraint(equalTo: itemView1.bottomAnchor, constant: padding),
            itemView2.heightAnchor.constraint(equalToConstant: height),
            
            dateLabel.topAnchor.constraint(equalTo: itemView2.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])

    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    private func configureUIElements(with userInfo: User) {
        let repoItemVC = GFRepoItemVC(user: userInfo)
        repoItemVC.delegate = self
       
        let followerItemVC = GFFollowerItemVC(user: userInfo)
        followerItemVC.delegate = self
        
        self.add(childVC: repoItemVC, to: self.itemView1)
        self.add(childVC: GFUserInfoHeaderVC(user: userInfo), to: self.headerView)
        self.add(childVC: followerItemVC, to: self.itemView2)
        
        self.dateLabel.text = "Github since \(userInfo.createdAt.convertToDisplayFormat())"
    }
    
    private func getUserInfo() {
        Task {
            do {
                let userInfo = try await NetworkManager.sharedInstance.getUserInfo(for: username)
                configureUIElements(with: userInfo)
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(alertTitle: "Unable to get user info", message: gfError.rawValue, buttonTitle: "OK")
                } else {
                    presentGFAlert()
                }
            }
        }
    }

    private func setupViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavBarItems() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
}

extension GFUserInfoVC: GFItemInfoVCDelegate {
    func didTapGithubProfile(for user: User) {
        guard let htmlUrl = URL(string: user.htmlUrl) else {
            presentGFAlert(alertTitle: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "OK")
            return
        }
        
        presentSafariVC(with: htmlUrl)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlert(alertTitle: "No Followers", message: "This user has no followers. What a shame 😤", buttonTitle: "So sad")
            return
        }
        
        self.delegate.didRequestFollowers(for: user.login)
        
        dismissVC()
    }
    
}
