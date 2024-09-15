//
//  UIColor Extension.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/12/24.
//

import UIKit

extension UIColor {
    static var defaultGreenColor: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .light ? UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 1.00) : UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 1.00)
        }
    }
}
