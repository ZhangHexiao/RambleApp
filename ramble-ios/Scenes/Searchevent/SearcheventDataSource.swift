//
//  SearcheventDataSource.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-12-03.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

protocol SearcheventDataSourceDelegate: class {
    
    func didTapSeeEventDetails(eventDetailsViewModel: ExpDetailViewModel)
    func tableViewDidReachBottom()
    func didTapSeeFilter()
    func didTapCityLabel()
    func afterTapLike(indexPath: IndexPath)
    func updateOneRow(indexPath: IndexPath)
    
}

class SearcheventDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var viewModel: SearcheventViewModel
    weak var delegate: SearcheventDataSourceDelegate?
    
    init(viewModel: SearcheventViewModel, delegate: SearcheventDataSourceDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    func inject(viewModel: SearcheventViewModel) {
        self.viewModel = viewModel
    }
}

extension SearcheventDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.typeCell(for: indexPath) {
        case .filter:
            return UITableViewCell()
        
        case .home:
//            let cell = tableView.dequeue(cellClass: HomeEventCell.self, indexPath:
//                indexPath)
//            cell.configure(with: viewModel.eventViewModel(at: indexPath))
//            return cell
            let cell = tableView.dequeue(cellClass: HomeExpCell.self, indexPath:
                indexPath)
            cell.configure(with: ExpDetailViewModel(event: viewModel.eventViewModel(at: indexPath).event), searchDelegate: self.delegate, indexPath: indexPath)
            return cell           
        
        case .empty:
            let cell = tableView.dequeue(cellClass: HomeEmptyCell.self, indexPath: indexPath)
            cell.configure(forTitle: "empty_result_text".localized)
            return cell
            
        case .notSearchResult:
            let cell = tableView.dequeue(cellClass: SearchEmptyCell.self, indexPath: indexPath)
            if viewModel.lastSearch == nil||viewModel.lastSearch == "" {
                switch UserDefaults.checkSearchFilter(){
                case false: cell.configure(searchType: "notSearch")
                case true:
                    cell.configure(searchType: "withFilter")
                }
            }
            else{
                cell.configure(text: viewModel.lastSearch!, searchType: "isSearch")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.typeCell(for: indexPath) {
//        case .startingSoon: return EventCell.kHeight
        case .filter: return 0
        case .home: return HomeExpCell.kHeight
        case .empty: return HomeEmptyCell.kHeight
        case .notSearchResult: return SearchEmptyCell.kHeight
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.typeCell(for: IndexPath(row: 0, section: section)) {
//      case .startingSoon: return SimpleTextSection.kHeight
        case .filter: return ButtonSection.kHeight
//        case .home: return SimpleTextSection.kHeight
        case .home: return 0.0
        case .empty: return 0.0
        case .notSearchResult: return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch viewModel.typeCell(for: IndexPath(row: 0, section: section)) {
            
        case .filter:
            let headerView = ButtonSection.fromNib()
//            ====should add the API to find the city=====
            headerView.configure(with: (viewModel.userLocation?.getCity().localized) ?? "Montreal", buttonTitle: " ", downArrow: true, buttonHide:false, delegate: self)
            headerView.setupLabelTap()
            return headerView
        case .home:
            let headerView = SimpleTextSection.fromNib()
            headerView.configure(with: viewModel.dateFormatted(for: section), appearanceType: .date)
            return headerView
        case .empty: return nil
        case .notSearchResult: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let eventDetailsViewModel = viewModel.selectEvent(for: viewModel.typeCell(for: indexPath), at: indexPath) else {
            return
        }
        
        delegate?.didTapSeeEventDetails(eventDetailsViewModel: eventDetailsViewModel)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        switch viewModel.typeCell(for: IndexPath(row: 0, section: section)) {
        case .home, .empty,.notSearchResult: return
        case .filter: return
        }
    }
}

// MARK: - ListFriendsCellDelegate
extension SearcheventDataSource {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 30.0 {
            print("Bottom")
            delegate?.tableViewDidReachBottom()
        }
    }
}

// MARK: - ButtonSectionDelegate
extension SearcheventDataSource: ButtonSectionDelegate {
    func didTapAction() {
        delegate?.didTapSeeFilter()
    }
    func didTapLabel() {
        delegate?.didTapCityLabel()
    }
}
