//
//  GFAlertContainerView.swift
//  GHFollowers_UIKit
//
//  Created by Jeffrey Sweeney on 1/1/24.
//

import UIKit

class GFAlertContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContainerView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor // Helps bring out the style in dark mode - "invisible" in light mode.
        translatesAutoresizingMaskIntoConstraints = false
    }
}
