//
//  PersistenceManager.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/17/24.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

class PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType) async throws {
        var retrievedFavorites = try await retrieveFavorites()
        
        switch actionType {
        case .add:
            guard !retrievedFavorites.contains(favorite) else {
                throw GFError.alreadyInFavorites
            }
            
            retrievedFavorites.append(favorite)
        case .remove:
            retrievedFavorites.removeAll { $0 == favorite }
        }
        
        try await saveFavorites(favorites: retrievedFavorites)
    }
    
    static func retrieveFavorites() async throws -> [Follower] {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            return favorites
        } catch {
            throw GFError.unableToFavorite
        }
    }
    
    static func saveFavorites(favorites: [Follower]) async throws {
        do {
            let encoder = JSONEncoder()
            let favoritesData = try encoder.encode(favorites)
            defaults.setValue(favoritesData, forKey: Keys.favorites)
        } catch {
            throw GFError.unableToFavorite
        }
    }
}
