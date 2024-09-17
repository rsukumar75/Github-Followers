//
//  GFError.swift
//  Github Followers
//
//  Created by Rishab Sukumar on 9/14/24.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error adding this user to favorites. Please try again."
    case alreadyInFavorites = "You've already added this user to favorites. You must really like them."
    
    
}
