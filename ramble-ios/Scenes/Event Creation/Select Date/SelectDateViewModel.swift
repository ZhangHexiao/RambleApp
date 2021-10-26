//
//  SelectDateViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-11.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol SelectDateViewModelDelegate: class {
    func didChangeDate()
    func didSelectPastDate()
}

enum DateType: String {
    case startAt = "Start date"
    case endAt = "End date"
    
    var localized: String {
        switch self {
        case .startAt: return "Start date".localized
        case .endAt: return "End date".localized
        }
    }
}

class SelectDateViewModel {
    
    weak var delegate: SelectDateViewModelDelegate?
    
    // We keep the reference of start date to compare with end date. End date can't be before start date.
    var minimumDate: Date?
    
    var dateType = DateType.startAt
    
    var selectedDate: Date = Date() {
        didSet {
            delegate?.didChangeDate()
        }
    }

    var navTitle: String {
        return dateType.localized
    }
    
    func injectDate(date: Date?, minimumDate: Date? = nil) {
        if let date = date, let minimumDate = minimumDate, date < minimumDate {
            selectedDate = minimumDate
        } else {
            selectedDate = date ?? minimumDate ?? Date()
        }
        self.minimumDate = minimumDate
    }
    
    func formattedDate() -> String {
        return "\(RMBDateFormat.dayMonth.combineDateAndHourWithAt(date: selectedDate, with: selectedDate, type: .hourMin))"
    }
    
    // Dont allow selecting date when it's in the past
    func selectTime(date: Date) {
        guard let date = Date.combine(date: selectedDate, time: date) else {
            return
        }
        
        if date < (minimumDate ?? Date()) {
            delegate?.didSelectPastDate()
            return
        }
        
        selectedDate = date
    }
    
    func selectDay(date: Date) {
        guard let date = Date.combine(date: date, time: selectedDate) else {
            return
        }
        selectedDate = date
    }

    func isSelectableDate(date: Date) -> Bool {
        // When seleting end date we compare with start date if any
        guard let startDate = minimumDate else {
             return date.isInFuture || date.isToday
        }
        return (date > startDate) || date.equals(startDate)
    }
}
