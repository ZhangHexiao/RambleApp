//
//  FriendsListController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-30.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class FriendsListController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: FriendsViewModel = FriendsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        loadLayout()
        
    }
    
    // MARK: Navigation
    private func loadNavbar() {
        navigationController?.setBack()
        navigationItem.title = "My Friends".localized
    }
    
    // MARK: Layout
    
    private func loadLayout() {
        view.backgroundColor = UIColor.AppColors.background
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: FriendCell.self)
        tableView.registerNib(cellClass: EventCell.self)
        tableView.backgroundColor = .clear
//        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FriendsListController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: FriendCell.self, indexPath: indexPath)
        
        var layoutFriendCellPosition = LayoutFriendCellPosition.any
        
        if indexPath.row == 0 && indexPath.row == viewModel.numberOfRows - 1 {
            layoutFriendCellPosition = .firstAndLast
        } else if indexPath.row == 0 {
            layoutFriendCellPosition = .first
        } else if indexPath.row != 0 && indexPath.row == viewModel.numberOfRows - 1 {
            layoutFriendCellPosition = .last
        }
        
        cell.configure(with: viewModel.friendCellViewModel(for: indexPath.row), position: layoutFriendCellPosition)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profile = ProfileController.instance
        profile.viewModel = viewModel.profileViewModel(for: indexPath.row)
        navigationController?.pushViewController(profile, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FriendCell.kHeight
    }
}

extension FriendsListController {
    static var instance: FriendsListController {
        guard let vc = Storyboard.Profile.viewController(for: .friendsList) as? FriendsListController else {
            assertionFailure("Something wrong while instantiating FriendsListController")
            return FriendsListController()
        }
        return vc
    }
}
