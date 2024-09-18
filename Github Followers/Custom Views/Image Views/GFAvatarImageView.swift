//
//  GFAvatarImageView.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/14/24.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let placeholderImage = UIImage(named: "avatar-placeholder")
    let imageCache = NetworkManager.sharedInstance.imageCache
    
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
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }

    func setImageWithURL(urlString: String) {
        let cacheKey = NSString(string: urlString)
        
        if let image = imageCache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        guard let imageURL = URL(string: urlString) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                guard let image = UIImage(data: data) else { return }
                
                imageCache.setObject(image, forKey: cacheKey)
                self.image = image
            } catch {
                return
            }
        }
    }
    
}
