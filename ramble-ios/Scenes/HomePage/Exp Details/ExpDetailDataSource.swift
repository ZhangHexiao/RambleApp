//
//  ExpDetailDataSource.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-10.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

protocol ExpDetailDataSourceDelegate: DisplayFullScreenImage {
        func didSelectLocation()
        func changeTitleOpaque(value: CGFloat)
//        func didTapContact()
//        func didTapSeeProfileDetails(profileViewModel: ProfileViewModel)
}
class ExpDetailDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var viewModel: ExpDetailViewModel
    weak var delegate: ExpDetailDataSourceDelegate?
    
    init(viewModel: ExpDetailViewModel, delegate: ExpDetailDataSourceDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    func inject(viewModel: ExpDetailViewModel) {
        self.viewModel = viewModel
    }
}

extension ExpDetailDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.typeCell(for: indexPath) {
        case .cover:
            let cell = tableView.dequeue(cellClass: HeaderContainer.self, indexPath: indexPath)
            cell.configure(withEvent: viewModel)
            return cell
        case .expSummary:
            let cell = tableView.dequeue(cellClass: ExpSummaryCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.eventViewModel)
            return cell
        case .hostInfo:
            let cell = tableView.dequeue(cellClass: HostInfoCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.eventViewModel, delegate: self.delegate as! HostInfoCellDelegate, buyTickets: viewModel.eventViewModel.hasBoughtTickets)
        return cell
        case .cancelled:
            let cell = tableView.dequeue(cellClass: CancelCell.self, indexPath: indexPath)
            return cell
        case .details:
            let cell = tableView.dequeue(cellClass: PlanningCell.self, indexPath: indexPath)
            return cell
        case .map:
            if viewModel.eventViewModel.hasBoughtTickets {
                let cell = tableView.dequeue(cellClass: EventMapCell.self, indexPath: indexPath)
                cell.configure(with: viewModel.eventViewModel.coordinates, delegate: self)
                return cell
            }
            let cell = tableView.dequeue(cellClass: ExpMapCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.eventViewModel.coordinates, delegate: self)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate,
extension ExpDetailDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.typeCell(for: indexPath) {
        case .cover, .cancelled, .details, .map: break
        default: break
        }
    }
}

// MARK: - Delegates from cells

extension ExpDetailDataSource: EventDetailsSelectLocationDelegate, DisplayFullScreenImage {

    func didTapImage(_ image: UIImage?, imageView: UIImageView?) {
        delegate?.didTapImage(image, imageView: imageView)
    }
    
    func didSelectLocation() {
        delegate?.didSelectLocation()
    }
}

extension ExpDetailDataSource {
    class func setupEventDetails(tableView: UITableView?) {
        tableView?.registerNib(cellClass: HeaderContainer.self)
        tableView?.registerNib(cellClass: ExpSummaryCell.self)
        tableView?.registerNib(cellClass: HostInfoCell.self)
        tableView?.registerNib(cellClass: PlanningCell.self)
        tableView?.registerNib(cellClass: ExpMapCell.self)
        tableView?.registerNib(cellClass: CancelCell.self)
        tableView?.registerNib(cellClass: EventMapCell.self)
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.remembersLastFocusedIndexPath = true
    }
}

extension ExpDetailDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 220.0 && scrollView.contentOffset.y > 30.0
        {
            self.delegate?.changeTitleOpaque(value: scrollView.contentOffset.y)
        }
    }
}
