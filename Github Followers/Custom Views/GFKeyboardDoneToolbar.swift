//
//  GFToolbar.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/14/24.
//

import UIKit

class GFKeyboardDoneToolbar: UIToolbar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        barStyle = .default
        items = [
            UIBarButtonItem.flexibleSpace(),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        ]
    }

    @objc func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
