//
//  NewEventViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-10.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol NewEventViewModelDelegate: class {
    func didUpdateContent()
    func didFail(error: String)
    func didSaveSuccess()
}

enum NewEventType {
    case new, edit, duplicate
}

class NewEventViewModel {
    
    weak var delegate: NewEventViewModelDelegate?
    
    var eventType: NewEventType = .new
    
    var event: Event?
    
    var name: String?
    var category: String?
    var eventImage: UIImage?
    var description: String?
    var owner: User?
    
    var startAt: Date?
    var endAt: Date?
    
    var location: String?
    var lat: Double?
    var lng: Double?
    
    let dateFormatter = DateFormatter()
    
    var isBookingRequired: Bool = false {
        didSet {
            updateTableViewList()
        }
    }
    
    var availableTickets: Int = -1
    var indicativePrice: Int = 0
    var webLink: String?

    var title: String {
        switch eventType {
        case .new: return "Create New Event".localized
        case .edit: return "Edit Event".localized
        case .duplicate: return "Duplicate Event".localized
        }
    }
    
    var tableViewList: [NewEventMenuType] = []

    init(event: Event?, eventType: NewEventType = .new) {
        self.eventType = eventType
        
        switch self.eventType {
        case .new:
            self.event = Event()

            endAt = Date.endDateDefault()
            startAt = Date()
            owner = User.current()
        case .edit:
            self.event = event
            name = event?.name
            category = event?.category
            description = event?.desc
            owner = event?.owner
            startAt = event?.startAt
            endAt = event?.endAt
            location = event?.location
            lat = event?.coordinates?.latitude
            lng = event?.coordinates?.longitude
            isBookingRequired = event?.isBookingRequired  ?? false
            availableTickets = event?.availableTickets ?? -1
            indicativePrice = event?.indicativePrice ?? 0
            webLink = event?.webLink
            
            ImageHelper.loadImage(data: event?.image) { [weak self] (image) in
                self?.eventImage = image
                self?.event?.cachedImage = image
                self?.delegate?.didUpdateContent()
            }
        case .duplicate:
            self.event = Event()
            name = event?.name
            category = event?.category
            description = event?.desc
            owner = event?.owner
            startAt = event?.startAt
            endAt = event?.endAt
            location = event?.location
            lat = event?.coordinates?.latitude
            lng = event?.coordinates?.longitude
            isBookingRequired = event?.isBookingRequired  ?? false
            availableTickets = event?.availableTickets ?? -1
            indicativePrice = event?.indicativePrice ?? 0
            webLink = event?.webLink
            
            ImageHelper.loadImage(data: event?.image) { [weak self] (image) in
                self?.eventImage = image
                self?.event?.cachedImage = image
                self?.delegate?.didUpdateContent()
            }
        }
        
        updateTableViewList()
    }
    
    func save() {
        prepareToSave()

        guard let event = event else {
            delegate?.didFail(error: RMBError.unknown.localizedDescription)
            return
        }
        
        EventManager().save(event: event, eventType: eventType) { [weak self] (error) in
            if let err = error {
                self?.delegate?.didFail(error: err)
                return
            }
            self?.delegate?.didSaveSuccess()
        }
    }
    
    private func prepareToSave() {
        
        event?.name = name
        event?.category = category
        event?.desc = description
        event?.owner = owner
        event?.startAt = startAt
        event?.endAt = endAt
        event?.location = location
        event?.lng = lng ?? 0
        event?.lat = lat ?? 0
        event?.isBookingRequired = isBookingRequired
        event?.availableTickets = availableTickets
        event?.indicativePrice = indicativePrice
        event?.webLink = webLink
        event?.cachedImage = eventImage
    }
}

extension NewEventViewModel {
    func hasEventImage() -> Bool {
        return eventImage != nil
    }
    
    func startAtFormatted() -> String? {
        // If it's empty shows default value
        guard let date = startAt else {
            return "Starts now".localized
        }
        
        // Starts today at 12:00 AM || Starts May 5 at 12:00 AM
        let strStart = "Starts".localized
        return strStart + " \(RMBDateFormat.dayMonth.combineDateAndHourWithAt(date: date, with: date, type: .hourMin))"
    }
    
    func endAtFormatted() -> String? {
        guard let date = endAt else {
            return nil
        }
        
        // Ends today at 12:00 AM || Ends May 5 at 12:00 AM
        let strEnds = "Ends".localized
        return strEnds + " \(RMBDateFormat.dayMonth.combineDateAndHourWithAt(date: date, with: date, type: .hourMin))"
    }
    
    func availableTicketsFormatted() -> String? {
        if availableTickets == -1 {
            return nil
        }
        
        let strTickets = "tickets".localized
        return "\(availableTickets) " + strTickets
    }
    
    func indicativePriceFormatted() -> String? {
        if indicativePrice == 0 {
            return nil
        }
        return CurrencyHelper.format(value: indicativePrice)
    }
    
    // Updates from the text field in the table view
    func update(_ text: String, for type: ExpandingFieldType) {
        switch type {
        case .description: description = text
        case .title: name = text
        case .weblink: webLink = text
        case .nbAvailableTickets:
            if text.isEmpty {
                availableTickets = -1
            } else {
                let parsedNumber = Int(text) ?? 0
                availableTickets = parsedNumber
            }
            
        case .indicativePrice:
            indicativePrice = text.toCurrencyInt()
        case .none: break
        }
        
        delegate?.didUpdateContent()
    }
    
    func categoryType() -> CategoryType? {
        guard let category = category else {
            return nil
        }
        return CategoryType.getCategoryType(by: category)
    }
    
    func update(_ date: Date, for type: DateType) {
        switch type {
        case .startAt: startAt = date
        case .endAt: endAt = date
        }
    }
}

extension NewEventViewModel {
    func numberOfRows(for section: Int) -> Int {
        return tableViewList.count
    }
    
    func typeCell(for indexPath: IndexPath) -> NewEventMenuType {
        return tableViewList[indexPath.row]
    }
}

extension NewEventViewModel {
    func sendButtonTheme() -> ButtonTheme {
        if hasFilledEvent() {
            return .red
        }
        return .disabled
    }
    
    func hasFilledEvent() -> Bool {
        
        // Any of basic info
        if name == nil || (name ?? "").isEmpty ||
            category == nil || (category ?? "").isEmpty ||
            description == nil || (description ?? "").isEmpty ||
            location == nil || (location ?? "").isEmpty ||
            eventImage == nil ||
            startAt == nil ||
            endAt == nil {
            return false
        }
        
        // If booking required is true, weblink is mandatory, we check the url format
        if isBookingRequired {
            if webLink == nil || !(webLink ?? "").isValidUrl {
                return false
            }
        }
        
        return true
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func validateEvent() -> String? {
        if name == nil || (name ?? "").isEmpty {
            return RMBError.invalidEventName.localizedDescription
        }
        
        if !hasEventImage() {
            return RMBError.invalidEventImage.localizedDescription
        }
        
        if category == nil || (category ?? "").isEmpty {
            return RMBError.invalidEventCategory.localizedDescription
        }

        if startAt == nil {
            return RMBError.invalidEventStartDate.localizedDescription
        }
        
        if endAt == nil {
            return RMBError.invalidEventEndDate.localizedDescription
        }
        
        if let startAt = startAt, let endAt = endAt {
            if startAt > endAt {
                return RMBError.invalidStartEventAfterEndDate.localizedDescription
            }
            
            if endAt < startAt {
                return RMBError.invalidEndEventBeforeStartDate.localizedDescription
            }
        }
        
        if lat == nil || lng == nil {
            return RMBError.invalidEventLocation.localizedDescription
        }
        
        if description == nil || (description ?? "").isEmpty {
            return RMBError.invalidEventDescription.localizedDescription
        }
        
        // If booking required is true, weblink is mandatory, we check the url format
        if isBookingRequired {
            if webLink == nil || !(webLink ?? "").isValidUrl {
                return RMBError.invalidEventWebLink.localizedDescription
            }
        }
        
        return nil
    }
}

extension NewEventViewModel {
    private func updateTableViewList() {
        tableViewList.removeAll()
        
        tableViewList.append(.eventName)
        tableViewList.append(.category)
        tableViewList.append(.startDate)
        tableViewList.append(.endDate)
        tableViewList.append(.location)
        tableViewList.append(.description)
        tableViewList.append(.isBookedRequired)
        
        if isBookingRequired {
            tableViewList.append(.nbAvailableTickets)
            tableViewList.append(.indicativePrice)
            tableViewList.append(.webLink)
        }
    }
}
