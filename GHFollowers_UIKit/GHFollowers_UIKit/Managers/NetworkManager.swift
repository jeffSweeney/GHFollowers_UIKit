//
//  NetworkManager.swift
//  GHFollowers_UIKit
//
//  Created by Jeffrey Sweeney on 1/3/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com/users/"
    
    private init() { }
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, .invalidUsername)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, respone, error in
            guard error == nil else {
                // Likely an internet connectivity issue - failure (5xx, 4xx, etc.) will be in the response.
                completed(nil, .unableToComplete)
                return
            }

            guard let respone = respone as? HTTPURLResponse, respone.statusCode == 200 else {
                completed(nil, .invalidResponse)
                return
            }
            
            guard let data = data else {
                completed(nil, .invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, .invalidData)
            }
        }
        
        task.resume()
    }
}
