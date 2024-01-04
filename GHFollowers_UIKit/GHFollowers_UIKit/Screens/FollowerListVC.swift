//
//  FollowerListVC.swift
//  GHFollowers_UIKit
//
//  Created by Jeffrey Sweeney on 1/1/24.
//

import UIKit

class FollowerListVC: UIViewController {
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { followers, error in
            guard let followers = followers else {
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened!", message: error!.rawValue, buttonTitle: "Ok")
                return
            }
            
            print("Follower count: \(followers.count)")
            print("Followers: \(followers)")
        }
    }
    
    // Required for edge case bug where you partially SWIPE back but don't complete the action and bounce back to this screen.
    // - SearchVC (even though we don't fully land on the screen) runs its viewWillAppear and hides the nav bar
    // - This VC now needs to unhide it as it reappears since viewDidLoad is only ran once on first landing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true) // Partial swipe makes animation snappy without this
    }
}
