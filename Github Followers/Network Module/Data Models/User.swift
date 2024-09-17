//
//  User.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/14/24.
//

import Foundation

struct User: Codable, Hashable {
    let login: String
    let htmlUrl: String
    let avatarUrl: String
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
}
