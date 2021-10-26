//
//  InterestedUsersController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class InterestedUsersController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: InterestedUsersViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadLayout()
        self.loadNavbar()
    }
    
    // MARK: Navigation
    func loadNavbar() {
        navigationController?.setBack()
        navigationItem.title = viewModel?.title ?? ""
        
        let itemShare = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_share"), style: .plain, target: self, action: #selector(actionShare))
        navigationItem.rightBarButtonItem = itemShare
    }
    
    // MARK: Layout
    func loadLayout() {
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: EventCell.self)
        tableView.registerNib(cellClass: FriendCell.self)
    }
    
    // MARK: - Actions
    
    @objc private func actionShare() {
        
    }
}

extension InterestedUsersController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel?.friendsViewModel.numberOfRows ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(cellClass: EventCell.self, indexPath: indexPath)
            cell.configure(with: viewModel?.eventViewModel)
            return cell
        case 1:
            let cell = tableView.dequeue(cellClass: FriendCell.self, indexPath: indexPath)
            if let viewModel = viewModel?.friendsViewModel {
                
                var layoutFriendCellPosition = LayoutFriendCellPosition.any
                
                if indexPath.row == 0 && indexPath.row == viewModel.numberOfRows - 1 {
                    layoutFriendCellPosition = .firstAndLast
                } else if indexPath.row == 0 {
                    layoutFriendCellPosition = .first
                } else if indexPath.row != 0 && indexPath.row == viewModel.numberOfRows - 1 {
                    layoutFriendCellPosition = .last
                }
                
                cell.configure(with: viewModel.friendCellViewModel(for: indexPath.row),
                               position: layoutFriendCellPosition)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
/* Block the user from seeing other's profile, this feature is in the users list*/
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0: break
//        case 1:
//            let profile = ProfileController.instance
//            guard let profileViewModel = viewModel?.friendsViewModel.profileViewModel(for: indexPath.row) else { return }
//            profile.viewModel = profileViewModel
//            navigationController?.pushViewController(profile, animated: true)
//        default: break
//
//        }
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 4))
            emptyView.backgroundColor = UIColor.clear
            return emptyView
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return EventCell.kHeight
        case 1: return FriendCell.kHeight
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1: return 4
        default: return 0
        }
    }
}

extension InterestedUsersController {
    static var instance: InterestedUsersController {
        guard let vc = Storyboard.Home.viewController(for: .interestedUsers) as? InterestedUsersController else {
            assertionFailure("Something wrong while instantiating InterestedUsersController")
            return InterestedUsersController()
        }
        return vc
    }
}
