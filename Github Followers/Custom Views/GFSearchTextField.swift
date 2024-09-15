//
//  GFTextField.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/12/24.
//

import UIKit

class GFSearchTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String) {
        super.init(frame: CGRectZero)
        
        self.placeholder = placeholder
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        textAlignment = .center
        tintColor = .label
        font = .preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        backgroundColor = .tertiarySystemBackground
        
        autocorrectionType = .no
        keyboardType = .default
        returnKeyType = .go
        enablesReturnKeyAutomatically = true
        
        let toolbar = GFKeyboardDoneToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 16))
        toolbar.sizeToFit()
        inputAccessoryView = toolbar
        
    }
    
}
