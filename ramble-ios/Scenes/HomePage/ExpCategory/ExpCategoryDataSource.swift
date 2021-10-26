//
//  CategoryDataSource.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-15.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//
import Foundation
import UIKit

protocol ExpCategoryDataSourceDelegate: class {
    
    func didTapSeeEventDetails(expDetailViewModel: ExpDetailViewModel)
    func tableViewDidReachBottom()
}

class ExpCategoryDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var viewModel: ExpCategoryViewModel
    weak var delegate: ExpCategoryDataSourceDelegate?
    
    init(viewModel: ExpCategoryViewModel, delegate: ExpCategoryDataSourceDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    func inject(viewModel: ExpCategoryViewModel) {
        self.viewModel = viewModel
    }
}

extension ExpCategoryDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.typeCell(for: indexPath) {
        case .startingSoon:
            let cell = tableView.dequeue(cellClass: EventCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.startingSoonEvent)
            return cell

        case .filter:
            return UITableViewCell()
        
        case .home:
            let cell = tableView.dequeue(cellClass: HomeExpCell.self, indexPath:
                indexPath)
            cell.configure(with: ExpDetailViewModel(event: viewModel.eventViewModel(at: indexPath).event), delegate: self.delegate as? HomeExpCellDelegate, indexPath: indexPath)
            return cell
        
        case .empty:
            let cell = tableView.dequeue(cellClass: HomeEmptyCell.self, indexPath: indexPath)
            cell.configure(forTitle: "empty_events_text".localized, forSubTitle:"empty_events_subTitle".localized)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.typeCell(for: indexPath) {
        case .startingSoon: return EventCell.kHeight
        case .filter: return 0
//        case .home: return UITableView.automaticDimension
        case .home: return HomeExpCell.kHeight
        case .empty: return HomeEmptyCell.kHeight
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.typeCell(for: IndexPath(row: 0, section: section)) {
//      case .startingSoon: return SimpleTextSection.kHeight
//      case .filter: return ButtonSection.kHeight
//      case .home: return SimpleTextSection.kHeight
        case .startingSoon: return 0.0
        case .filter: return 0.0
        case .home: return 0.0
        case .empty: return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch viewModel.typeCell(for: IndexPath(row: 0, section: section)) {
        case .home:
            return nil
        case .empty: return nil
        case .filter, .startingSoon: return nil    
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let expDetailsViewModel = viewModel.selectEvent(for: viewModel.typeCell(for: indexPath), at: indexPath) else {
            return
        }
        
        delegate?.didTapSeeEventDetails(expDetailViewModel: expDetailsViewModel)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        switch viewModel.typeCell(for: IndexPath(row: 0, section: section)) {
        case .startingSoon, .home, .empty: return
        case .filter: return
//        case .home:
//            return
//        case .empty:
//            return
        }
    }
}

// MARK: - ListFriendsCellDelegate
extension ExpCategoryDataSource {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 30.0 {
            delegate?.tableViewDidReachBottom()
        }
    }
}


