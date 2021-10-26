//
//  NewEventDataSource.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-28.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

protocol NewEventDataSourceDelegate: class {
    // Route
    func didTapSelectCategory()
    func didTapSelectDate(type: DateType)
    func didTapSelectLocation()
    
    // Cell Delegate actions
    func switchCellDidChange(status: Bool)
    func didUpdateTableViewHeight(indexPath: IndexPath)
    func didTapToShowCamera()
    func didEndEditing(text: String, for type: ExpandingFieldType)
    // ===Add function for duplicating event==
    func didEndDuplicating(text: String, for type: ExpandingFieldType)
    // =======================================
}

class NewEventDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var viewModel: NewEventViewModel
    weak var delegate: NewEventDataSourceDelegate?
    
    var expandingTitleCellHeight: CGFloat = ExpandingTextViewCell.kBaseHeight
    var expandingDescriptionCellHeight: CGFloat = ExpandingTextViewCell.kBaseHeight
    
    init(viewModel: NewEventViewModel, delegate: NewEventDataSourceDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    func inject(viewModel: NewEventViewModel) {
        self.viewModel = viewModel
    }
}

extension NewEventDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: section)
    }
    
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.typeCell(for: indexPath) {
        case .eventName:
            if viewModel.eventType == .edit || viewModel.eventImage != nil {
                let cell = tableView.dequeue(cellClass: NewEventCellImage.self, indexPath: indexPath)
                cell.configure(with: viewModel.eventImage ?? #imageLiteral(resourceName: "ic_camera"), placeHolder: NewEventMenuType.eventName.localized(),
                               content: viewModel.name,
                               type: .title,
                               delegate: self)
                return cell
            } else {
                let cell = tableView.dequeue(cellClass: ExpandingTextViewCell.self, indexPath: indexPath)
                cell.configure(placeHolder: NewEventMenuType.eventName.localized(),
                               content: viewModel.name,
                               type: .title,
                               delegate: self,
                               buttonTitle: nil,
                               buttonIcon: #imageLiteral(resourceName: "ic_camera"))
                return cell
            }
            
        case .category:
            if let category = viewModel.categoryType() {
                let cell = tableView.dequeue(cellClass: CategoryCell.self, indexPath: indexPath)
                cell.configure(with: category, textColor: .white)
                return cell
            } else {
                let cell = tableView.dequeue(cellClass: SimpleTextCell.self, indexPath: indexPath)
                cell.configure(with: NewEventMenuType.category.localized(), color: UIColor.AppColors.placeHolderGray)
                return cell
            }
            
        case .startDate:
            let cell = tableView.dequeue(cellClass: SimpleTextCell.self, indexPath: indexPath)
            cell.configure(with: NewEventMenuType.startDate.localized(), content: viewModel.startAtFormatted())
            return cell
            
        case .endDate:
            let cell = tableView.dequeue(cellClass: SimpleTextCell.self, indexPath: indexPath)
            cell.configure(with: NewEventMenuType.endDate.localized(), content: viewModel.endAtFormatted())
            return cell
            
        case .location:
            let cell = tableView.dequeue(cellClass: SimpleTextCell.self, indexPath: indexPath)
            cell.configure(with: NewEventMenuType.location.localized(), content: viewModel.location)
            return cell
            
        case .description:
            let cell = tableView.dequeue(cellClass: ExpandingTextViewCell.self, indexPath: indexPath)
            cell.configure(placeHolder: NewEventMenuType.description.localized(), content: viewModel.description, type: .description, delegate: self)
            return cell
            
        case .isBookedRequired:
            let cell = tableView.dequeue(cellClass: NewEventCellSwitch.self, indexPath: indexPath)
            cell.configure(with: viewModel.isBookingRequired, delegate: self)
            return cell
            
        case .nbAvailableTickets:
            let cell = tableView.dequeue(cellClass: ExpandingTextViewCell.self, indexPath: indexPath)
            cell.configure(placeHolder: NewEventMenuType.nbAvailableTickets.localized(), content: viewModel.availableTicketsFormatted(), type: .nbAvailableTickets, delegate: self)
            return cell
            
        case .indicativePrice:
            let cell = tableView.dequeue(cellClass: ExpandingTextViewCell.self, indexPath: indexPath)
            cell.configure(placeHolder: NewEventMenuType.indicativePrice.localized(), content: viewModel.indicativePriceFormatted(), type: .indicativePrice, delegate: self)
            return cell
            
        case .webLink:
            let cell = tableView.dequeue(cellClass: ExpandingTextViewCell.self, indexPath: indexPath)
            cell.configure(placeHolder: NewEventMenuType.webLink.localized(), content: viewModel.webLink, type: .weblink, delegate: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.typeCell(for: indexPath) {
        case .eventName:
            if viewModel.hasEventImage() {
                return expandingTitleCellHeight + NewEventCellImage.kBaseHeight
            } else {
                return expandingTitleCellHeight
            }
        case .description: return expandingDescriptionCellHeight
        case .category, .startDate, .endDate, .location, .isBookedRequired, .nbAvailableTickets, .indicativePrice, .webLink: return SimpleTextCell.kHeight
        }
    }
}

// MARK: - UITableViewDelegate,
extension NewEventDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.typeCell(for: indexPath) {
        case .category:
            delegate?.didTapSelectCategory()
        case .startDate:
            delegate?.didTapSelectDate(type: .startAt)
        case .endDate:
            delegate?.didTapSelectDate(type: .endAt)
        case .location:
            delegate?.didTapSelectLocation()
        case .eventName, .description, .isBookedRequired, .nbAvailableTickets, .indicativePrice, .webLink: break
        }
    }
}

// MARK: - NewEventCellSwitchDelegate
extension NewEventDataSource: NewEventCellSwitchDelegate {
    func switchCellDidChange(status: Bool) {
        delegate?.switchCellDidChange(status: status)
    }
}

// MARK: - ExpandingTextViewCellDelegate
extension NewEventDataSource: TextViewCellDelegate {
    func didUpdate(height: CGFloat, for type: ExpandingFieldType) {
        
        let indexPath: IndexPath
        switch type {
        case .description:
            expandingDescriptionCellHeight = height
            indexPath = IndexPath(row: NewEventMenuType.description.rawValue, section: 0)
        case .title:
            expandingTitleCellHeight = height
            indexPath = IndexPath(row: NewEventMenuType.eventName.rawValue, section: 0)
        case .weblink, .indicativePrice, .nbAvailableTickets, .none: return
            
        }
        
        delegate?.didUpdateTableViewHeight(indexPath: indexPath)
        
    }
    
    func didTapCellButton() {
        delegate?.didTapToShowCamera()
    }
    
    func didEndEditing(text: String, for type: ExpandingFieldType) {
        delegate?.didEndEditing(text: text, for: type)
    }
}

extension NewEventDataSource {
    class func setupNewEvent(tableView: UITableView?) {
        tableView?.registerNib(cellClass: NewEventCellImage.self)
        tableView?.registerNib(cellClass: TextFieldCell.self)
        tableView?.registerNib(cellClass: SimpleTextCell.self)
        tableView?.registerNib(cellClass: CategoryCell.self)
        tableView?.registerNib(cellClass: NewEventCellSwitch.self)
        tableView?.registerNib(cellClass: ExpandingTextViewCell.self)
        tableView?.backgroundColor = .clear
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
}
