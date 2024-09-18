//
//  UIViewController+Alert.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/14/24.
//

import UIKit
import SafariServices

fileprivate var loadingView: GFLoadingView? = nil

extension UIViewController {
    func presentGFAlert(
        alertTitle: String? = "Something went wrong",
        message: String? = "We were unable to complete your task at this time. Please try again.",
        buttonTitle: String? = "OK"
    ) {
        let alertController = GFAlertController(alertTitle: alertTitle, message: message, buttonTitle: buttonTitle)
        alertController.modalPresentationStyle = .overFullScreen
        alertController.modalTransitionStyle = .crossDissolve
        
        present(alertController, animated: true)
    }
    
    func showLoadingView() {
        loadingView = GFLoadingView(frame: self.view.bounds)
        guard let loadingView = loadingView else { return }
        
        self.view.addSubview(loadingView)
        self.view.bringSubviewToFront(loadingView)
        
        UIView.animate(withDuration: 0.15) {
            loadingView.alpha = 0.8
        }
        
        loadingView.loadingIndicator.startAnimating()
        
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            loadingView?.loadingIndicator.stopAnimating()
            loadingView?.removeFromSuperview()
            loadingView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .defaultGreenColor
        present(safariVC, animated: true)
    }
    
}
