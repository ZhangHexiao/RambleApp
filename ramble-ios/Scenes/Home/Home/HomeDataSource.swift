////
////  HomeDataSource.swift
////  ramble-ios
////
////  Created by Hexiao Zhang Ramble Technologies Inc. on 2020-06-01.
////  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//protocol HomeDataSourceDelegate: class {
//    
//    func didTapSeeEventDetails(eventDetailsViewModel: EventDetailsViewModel)
//    func tableViewDidReachBottom()
//    func didTapSeeFilter()
//}
//
//class HomeDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
//    
//    private var viewModel: HomeViewModel
//    weak var delegate: HomeDataSourceDelegate?
//    
//    init(viewModel: HomeViewModel, delegate: HomeDataSourceDelegate) {
//        self.viewModel = viewModel
//        self.delegate = delegate
//    }
//    
//    func inject(viewModel: HomeViewModel) {
//        self.viewModel = viewModel
//    }
//}
//
//extension HomeDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel.numberOfSections()
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfRows(for: section)
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch viewModel.typeCell(for: indexPath) {
//        case .startingSoon:
//            let cell = tableView.dequeue(cellClass: EventCell.self, indexPath: indexPath)
//            cell.configure(with: viewModel.startingSoonEvent)
//            return cell
//        
//        case .filter:
//            return UITableViewCell()
//        
//        case .home:
//            let cell = tableView.dequeue(cellClass: HomeEventCell.self, indexPath:
//                indexPath)
//            cell.configure(with: viewModel.eventViewModel(at: indexPath))
//            return cell
//        
//        case .empty:
//            let cell = tableView.dequeue(cellClass: HomeEmptyCell.self, indexPath: indexPath)
//            cell.configure(forTitle: "empty_events_text".localized, forSubTitle:"empty_events_subTitle".localized)
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch viewModel.typeCell(for: indexPath) {
//        case .startingSoon: return EventCell.kHeight
//        case .filter: return 0
//        case .home: return UITableView.automaticDimension
//        case .empty: return HomeEmptyCell.kHeight
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        switch viewModel.typeCell(for: IndexPath(row: 0, section: section)) {
//        case .startingSoon: return SimpleTextSection.kHeight
//        case .filter: return ButtonSection.kHeight
/////     Currently not show date information
////      case .home: return SimpleTextSection.kHeight
//        case .home: return 0.0
//        case .empty: return 0.0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        switch viewModel.typeCell(for: IndexPath(row: 0, section: section)) {
//        case .startingSoon:
//            let headerView = SimpleTextSection.fromNib()
//            headerView.configure(with: "Starting soon".localized, appearanceType: .category)
//            return headerView
//            
//        case .filter:
//            let headerView = ButtonSection.fromNib()
//            headerView.configure(with: " ", buttonTitle: " ", buttonHide:false, delegate: self)
//            return headerView
//            
//        case .home:
/////     Currently not show date information
////            let headerView = SimpleTextSection.fromNib()
////            headerView.configure(with: viewModel.dateFormatted(for: section), appearanceType: .date)
////            return headerView
//            return nil
//        case .empty: return nil
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let eventDetailsViewModel = viewModel.selectEvent(for: viewModel.typeCell(for: indexPath), at: indexPath) else {
//            return
//        }
//        
//        delegate?.didTapSeeEventDetails(eventDetailsViewModel: eventDetailsViewModel)
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        switch viewModel.typeCell(for: IndexPath(row: 0, section: section)) {
//        case .startingSoon, .home, .empty: return
//        case .filter: return
//        }
//    }
//}
//
//// MARK: - ListFriendsCellDelegate
//extension HomeDataSource {
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        // UITableView only moves in one direction, y axis
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//        
//        // Change 10.0 to adjust the distance from bottom
//        if maximumOffset - currentOffset <= 30.0 {
//            print("Bottom")
//            delegate?.tableViewDidReachBottom()
//        }
//    }
//}
//
//// MARK: - ButtonSectionDelegate
//extension HomeDataSource: ButtonSectionDelegate {
//    func didTapLabel() {
//        delegate?.didTapSeeFilter()
//    }
//    
//    func didTapAction() {
//        delegate?.didTapSeeFilter()
//    }
//}
