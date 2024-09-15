//
//  Follower.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/14/24.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
}
