//
//  ErrorMessage.swift
//  GHFollowers_UIKit
//
//  Created by Jeffrey Sweeney on 1/4/24.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username comleted an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
