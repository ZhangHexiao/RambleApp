//
//  ProfileDataSource.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-29.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileDataSourceDelegate: class {
    func didTapSeeBand()
    func didTapSeeEventDetails(eventDetailsViewModel: ExpDetailViewModel)
//    func didTapSeeAllFriends()
//    func didSelectFacebook()
    func didTapAction(for section: SectionType)
    func didTapSeeProfileDetails(profileViewModel: ProfileViewModel)
}

class ProfileDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var viewModel: ProfileViewModel
    weak var delegate: ProfileDataSourceDelegate?

    init(viewModel: ProfileViewModel, delegate: ProfileDataSourceDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    func inject(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
}

extension ProfileDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tableViewList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.typeCell(for: indexPath) {
        case .cover:
            let cell = tableView.dequeue(cellClass: ProfileCoverCell.self, indexPath: indexPath)
            cell.configure(with: viewModel)
            return cell
            
//        case .friends:
//            let cell = tableView.dequeue(cellClass: ListFriendsCell.self, indexPath: indexPath)
//            cell.configure(with: viewModel.friendsViewModel, delegate: self)
//            return cell
//            
//        case .facebookConnect:
//            let cell = tableView.dequeue(cellClass: ConnectFacebookCell.self, indexPath: indexPath)
//            cell.delegate = self
//            return cell
            
        case .section:
            return UITableViewCell()
            
        case .myTickets:
            let cell = tableView.dequeue(cellClass: EventCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.event(by: indexPath, of: .bought))
            return cell
            
        case .interested:
            let cell = tableView.dequeue(cellClass: EventCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.event(by: indexPath, of: .interested))
            return cell
            
        case .created:
            let cell = tableView.dequeue(cellClass: EventCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.event(by: indexPath, of: .created))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.typeCell(for: indexPath) {
        case .cover: return ProfileCoverCell.kHeight
//        case .friends: return ListFriendsCell.kHeight
//        case .facebookConnect: return ConnectFacebookCell.kHeight
        case .section: return 0.0
        case .myTickets, .interested, .created: return EventCell.kHeight
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.typeCell(for: IndexPath(item: 0, section: section)) {
        case .cover : return 0
//        case .friends, .facebookConnect : return 0
        case .section: return ButtonSection.kHeight
        case .myTickets: return IconTextButtonSection.kHeight + 8
        case .interested, .created: return IconTextButtonSection.kHeight + 24
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.typeCell(for: IndexPath(item: 0, section: section)) {
        case .cover : return nil
//        case .friends, .facebookConnect : return nil
        case .section:
            let headerView = ButtonSection.fromNib()
            headerView.configure(with: "Events".localized, delegate: nil)
            return headerView
            
        case .myTickets:
            let headerView = IconTextButtonSection.fromNib()
            headerView.configure(with: viewModel.numberOfEvents(by: .bought), type: .myTickets, delegate: self)
            return headerView
            
        case .interested:
            let headerView = IconTextButtonSection.fromNib()
            headerView.configure(with: viewModel.numberOfEvents(by: .interested), type: .interested, delegate: self)
            return headerView
            
        case .created:
            let headerView = IconTextButtonSection.fromNib()
            headerView.configure(with: viewModel.numberOfEvents(by: .created), type: .created, delegate: self)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch viewModel.typeCell(for: indexPath) {
        case .cover:
            delegate?.didTapSeeBand()
        
        case .myTickets:
            delegate?.didTapSeeEventDetails(eventDetailsViewModel: viewModel.eventDetailsViewModel(by: .bought))
        
        case .interested:
            delegate?.didTapSeeEventDetails(eventDetailsViewModel: viewModel.eventDetailsViewModel(by: .interested))
        
        case .created:
            delegate?.didTapSeeEventDetails(eventDetailsViewModel: viewModel.eventDetailsViewModel(by: .created))
        case .section: return
        
//        case .friends, .facebookConnect : return
        }

    }

}
// MARK: - ListFriendsCellDelegate
//extension ProfileDataSource: ListFriendsCellDelegate {
//    func didTapSeeAllFriends() {
//        delegate?.didTapSeeAllFriends()
//    }
//
//    func didTapSeeFriend(profileViewModel: ProfileViewModel) {
//        delegate?.didTapSeeProfileDetails(profileViewModel: profileViewModel)
//    }
//}

// MARK: - ConnectFacebookCellDelegate
//extension ProfileDataSource: ConnectFacebookCellDelegate {
//    func didSelectFacebook() {
//        delegate?.didSelectFacebook()
//    }
//}

extension ProfileDataSource: SectionDelegate {
    func didTapAction(for section: SectionType) {
        delegate?.didTapAction(for: section)
    }
}
