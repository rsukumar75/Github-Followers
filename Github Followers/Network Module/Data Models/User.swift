//
//  User.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/14/24.
//

import Foundation

struct User: Codable, Hashable {
    var login: String
    var htmlURL: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var followers: Int
    var following: Int
    var createdAt: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
}
