//
//  FollowerListVC.swift
//  GHFollowers_UIKit
//
//  Created by Jeffrey Sweeney on 1/1/24.
//

import UIKit

class FollowerListVC: UIViewController {
    enum Section {
        case main
    }
    
    var username: String!
    var followers = [Follower]()
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureVC()
        getFollowers()
        configureDataSource()
    }
    
    // Required for edge case bug where you partially SWIPE back but don't complete the action and bounce back to this screen.
    // - SearchVC (even though we don't fully land on the screen) runs its viewWillAppear and hides the nav bar
    // - This VC now needs to unhide it as it reappears since viewDidLoad is only ran once on first landing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true) // Partial swipe makes animation snappy without this
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    
    private func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minItemSpacing: CGFloat = 10
        let availableWidth = width - (padding*2) - (minItemSpacing*2)
        let itemWidth = availableWidth/3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40) // Label in FollowerCell is 20 - probably sufficient
        
        return flowLayout
    }
    
    private func getFollowers() {
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            switch result {
            case .success(let followers):
                self.followers = followers
                self.updateData()
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened!", message: error.rawValue, buttonTitle: "Ok")
                return
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}
