//
//  ViewController.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/9/24.
//

import UIKit

class SearchUserVC: UIViewController{
    let searchBar: GFSearchTextField = GFSearchTextField(placeholder: "Enter a username")
    let searchButton: GFButton = GFButton(backgroundColor: UIColor.defaultGreenColor, title: "Get Followers")
    let ghLogoImageView = GFImageView()
    
    var isUsernameEntered: Bool {
        return !(searchBar.text?.isEmpty ?? true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.setupDismissKeyboardGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        self.view.addGestureRecognizer(tap)
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        self.setupLogoImageView()
        self.setupSearchBar()
        self.setupSearchButton()
    }
    
    func setupSearchButton() {
        // Add search button
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(getFollowers), for: .touchUpInside)
        searchButton.showDisabled = true
        
        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48),
            searchButton.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            searchButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor)
        ])
    }
    
    func setupSearchBar() {
        // Add Search bar
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.topAnchor.constraint(equalTo: ghLogoImageView.bottomAnchor, constant: 48),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        searchBar.delegate = self
    }
    
    func setupLogoImageView() {
        // Add Github logo
        ghLogoImageView.image = UIImage(named: "gh-logo")
        view.addSubview(ghLogoImageView)
        
        NSLayoutConstraint.activate([
            ghLogoImageView.heightAnchor.constraint(equalToConstant: 200),
            ghLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ghLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80)
        ])
    }
    
    @objc func getFollowers() {
        // Dismiss keyboard
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        
        guard isUsernameEntered else {
            self.presentGFAlertOnMainThread(alertTitle: "Empty Username", message: "Please enter a username. We need to know who to look for 😁", buttonTitle: "OK")
            
            return
        }
        
        if let username = searchBar.text {
            let followerListVC = FollowerListVC(username: username)
            self.navigationController?.pushViewController(followerListVC, animated: true)
        }
    }
        

}

extension SearchUserVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.getFollowers()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, textField == searchBar else {
            return false
        }
            
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)
        searchButton.showDisabled = newText.isEmpty
        return true
    }
}
