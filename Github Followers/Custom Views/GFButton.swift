//
//  GFButton.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/12/24.
//

import UIKit

class GFButton: UIButton {
    var baseBackgroundColor: UIColor = .defaultGreenColor
    var showDisabled: Bool = false {
        didSet {
            backgroundColor = showDisabled ? UIColor.lightGray : baseBackgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: CGRectZero)
        
        baseBackgroundColor = backgroundColor
        setTitle(title, for: .normal)
        
        configure()
    }
    
    private func configure() {
        backgroundColor = baseBackgroundColor
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
    
}
