//
//  GFImageView.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/12/24.
//

import UIKit

class GFImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRectZero)
        configure()
    }
    
    private func configure() {
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }

}
