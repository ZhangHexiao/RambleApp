////
////  EventDetailsListDataSource.swift
////  ramble-ios
////
////  Created by Ramble Technologies Inc. on 2018-11-22.
////  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//protocol EventDetailsListDataSourceDelegate: DisplayFullScreenImage {
//    func didSelectLocation()
//    func didSelectOutsideTickets()
//    func didTapSeeAllFriends()
//    func didTapSeeMyTickets()
//    func didTapSeeProfileDetails(profileViewModel: ProfileViewModel)
//}
//
//class EventDetailsListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
//    
//    private var viewModel: EventDetailsViewModel
//    weak var delegate: EventDetailsListDataSourceDelegate?
//    
//    init(viewModel: EventDetailsViewModel, delegate: EventDetailsListDataSourceDelegate) {
//        self.viewModel = viewModel
//        self.delegate = delegate
//    }
//    
//    func inject(viewModel: EventDetailsViewModel) {
//        self.viewModel = viewModel
//    }
//}
//
//extension EventDetailsListDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfRows(for: section)
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        switch viewModel.typeCell(for: indexPath) {
//        case .cover:
//            let cell = tableView.dequeue(cellClass: EventCoverCell.self, indexPath: indexPath)
//            cell.configure(eventName: viewModel.eventViewModel.eventName,
//                           eventImage: viewModel.eventViewModel.eventImage,
//                           owner: viewModel.eventViewModel.ownerName,
//                           ownerImage: viewModel.eventViewModel.ownerImage,
//                           isVerified: viewModel.eventViewModel.ownerIsVerified,
//                           hasFriendsInterested: viewModel.hasFriendsInterested)
//            
//            cell.delegate = self
//            return cell
//            
//        case .friends:
//            let cell = tableView.dequeue(cellClass: EventDetailsListFriendsCell.self, indexPath: indexPath)
//            cell.configure(with: viewModel.eventViewModel.friendsViewModel, delegate: self)
//            return cell
//            
//        case .seeMyTickets:
//            let cell = tableView.dequeue(cellClass: SeeTicketsCell.self, indexPath: indexPath)
//            return cell
//            
//        case .cancelled:
//            let cell = tableView.dequeue(cellClass: CancelCell.self, indexPath: indexPath)
//            return cell
//            
//        case .details:
//            let cell = tableView.dequeue(cellClass: EventDetailsCell.self, indexPath: indexPath)
//            cell.configure(with: viewModel.eventViewModel, eventDetailsSelectLocationDelegate: self, eventDetailsSelectOutsideTicketsDelegate: self)
//            return cell
//            
//        case .map:
//            let cell = tableView.dequeue(cellClass: EventMapCell.self, indexPath: indexPath)
//            cell.configure(with: viewModel.eventViewModel.coordinates, delegate: self)
//            return cell
//        }
//    }
//}
//
//// MARK: - UITableViewDelegate,
//extension EventDetailsListDataSource {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch viewModel.typeCell(for: indexPath) {
//        case .seeMyTickets:
//            delegate?.didTapSeeMyTickets()
//        case .cover, .friends, .cancelled, .details, .map: break
//        }
//    }
//}
//
//// MARK: - Delegates from cells
//extension EventDetailsListDataSource: EventDetailsSelectLocationDelegate, EventDetailsSelectOutsideTicketsDelegate, EventDetailsListFriendsCellDelegate, DisplayFullScreenImage {
//    
//    func didTapSeeFriend(profileViewModel: ProfileViewModel) {
//        delegate?.didTapSeeProfileDetails(profileViewModel: profileViewModel)
//    }
//    
//    func didTapImage(_ image: UIImage?, imageView: UIImageView?) {
//        delegate?.didTapImage(image, imageView: imageView)
//    }
//    
//    func didSelectLocation() {
//        delegate?.didSelectLocation()
//    }
//    
//    func didSelectOutsideTickets() {
//        delegate?.didSelectOutsideTickets()
//    }
//    
//    func didTapSeeAllFriends() {
//        delegate?.didTapSeeAllFriends()
//    }
//}
//
//extension EventDetailsListDataSource {
//    class func setupEventDetails(tableView: UITableView?) {
//        tableView?.registerNib(cellClass: EventCoverCell.self)
//        tableView?.registerNib(cellClass: EventDetailsListFriendsCell.self)
//        tableView?.registerNib(cellClass: SeeTicketsCell.self)
//        tableView?.registerNib(cellClass: EventDetailsCell.self)
//        tableView?.registerNib(cellClass: EventMapCell.self)
//        tableView?.registerNib(cellClass: CancelCell.self)
//        tableView?.rowHeight = UITableView.automaticDimension
//        tableView?.remembersLastFocusedIndexPath = true
//    }
//}
