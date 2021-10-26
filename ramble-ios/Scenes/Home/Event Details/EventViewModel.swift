//
//  EventViewModel.swift
//  ramble-ios
//
//  Created by Hexiao Zhang, Ramble Technologies Inc. on 2018-10-04.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

class EventViewModel {
    
    var event: Event
    
    var isSelected: Bool = false
    
    var eventName: String {
        return event.name ?? ""
    }
    
    var eventImage: UIImage? {
        return event.cachedImage
    }
    
    var ownerName: String {
        
        if hasBadge, let organizationName = event.owner?.organizationName {
            return organizationName
        } else {
            if let firstName = event.owner?.name {
                if let lastName = event.owner?.lastName {
                    return "\(firstName) \(lastName)"
                } else {
                    return firstName
                }
            }
            return ""
        }
    }
    
    var ownerImage: UIImage? {
        return event.owner?.cachedProfileImage
    }
    
    var hasBadge: Bool {
        return event.hasBadge
    }
    
    var ownerIsVerified: Bool {
        return event.owner?.isVerifiedAccount ?? false
    }
    
    var dateFormatted: String {
        //      Saturday, May 5, 9pm to Monday, May 10, 12am
        if let startAt = event.startAt, let endAt = event.endAt {
            return RMBDateFormat.fullFormat.combineStartAtAndEndAt(startAt: startAt, endAt: endAt, type: .fullFormat)
        } else {
            return ""
        }
    }
    
    var homeDateFormatted: String {
        //Saturday, May 5, 9pm
        return RMBDateFormat.fullFormat.formatted(date: event.startAt).capitalizingFirstLetter()
    }
    
    var eventDateFormatted: String {
        return RMBDateFormat.weekdayMonthDayHour.formatted(date: event.startAt).capitalizingFirstLetter()
    }
    
    var ticketsAvailable: String {
        
        if isTicketsAvailable {
            let string = "tickets available".localized
            return "\(event.availableTickets - event.ticketsSold) \(string)"
        }
        
        return "No tickets for sale".localized
    }
    
    var isTicketsAvailable: Bool {
        if event.availableTickets <= 0 { return false }
        
        return event.availableTickets > -1 || event.ticketsSold <= event.availableTickets
    }
    
    var rangePrice: String {
        
        //        if !isTicketsAvailable {
        //            return ""
        //        }
        
        if let rangePrice = event.rangePrice {
            return rangePrice
        }
        
        if event.indicativePrice > 0 {
            return CurrencyHelper.format(value: event.indicativePrice)
        }
        
        return "Free".localized
    }
    
    var minPrice: String {
        
        if let rangePrice = event.rangePrice {
            let array = rangePrice.components(separatedBy: " ")
            switch array[0] {
            case "$":
                if array[1].contains("."){
                    let removeDecimal = array[1].components(separatedBy: ".")
                    if removeDecimal[0] == "0" {return array[1]}
                    return removeDecimal[0]
                }
            case "Free": return "Free"
            default: return "Free"
            }
        }
        
        if event.indicativePrice > 0 {
            return CurrencyHelper.format(value: event.indicativePrice)
        }
        
        return "Free".localized
    }
    
    var location: String {
        return event.location ?? ""
    }
    
    var description: String {
        return event.desc ?? ""
    }
    
    var coordinates: (lat: Double, lng: Double) {
        return (event.coordinates?.latitude ?? 0, event.coordinates?.longitude ?? 0)
    }
    var coordinate: (latitude: Double, longitude: Double) {
        return (event.coordinates?.latitude ?? 0, event.coordinates?.longitude ?? 0)
    }
    var status: EventStatus {
        return event.eventStatusEnum
    }
    
    var startAt: Date? {
        return event.startAt
    }
    
    var endAt: Date? {
        return event.endAt
    }
    
    var owner: User? {
        return event.owner
    }
    
    var isMine: Bool {
        return event.owner == User.current()
    }
    
    var hasBeenInterested: Bool {
        return event.hasEventBeenInterested
    }
    
    var eventStatus: EventStatus {
        return EventStatus(rawValue: event.eventStatus ?? "") ?? .active
    }
    
    var hasBoughtTickets: Bool {
        return event.myTickets != nil
    }
    
    var hasReviewed: Bool {
        return event.reviews != nil
    }
    
    var ticketsBoughtViewModel: [TicketBoughtViewModel]? {
        return event.myTickets?.compactMap { TicketBoughtViewModel(ticketBought: $0) }
    }
    
    var friendsViewModel: FriendsViewModel {
        return FriendsViewModel(users: event.friends)
    }
    
    var ticketsWebLinkString: String? {
        return event.webLink
    }
    
    var averageStar: String {
        return event.averageStar ?? "0.00"
    }
    
    var ticketsWebLinkURL: URL? {
        let link = event.webLink ?? ""
        let numberOfHttp =  link.components(separatedBy: "http").count
        if numberOfHttp > 2 { // the link contain other link
            if let end = link.firstIndex(of: "<") {
                let newLink = link[link.startIndex..<end]
                return URL(string: String(newLink))
            } else {
                return nil
            }
        }
        return URL(string: link)
    }
    
    init(event: Event) {
        self.event = event
        event.eventStatusEnum = EventStatus(rawValue: event.eventStatus ?? "") ?? .active
    }
    
    func inject(event: Event) {
        self.event = event
        event.eventStatusEnum = EventStatus(rawValue: event.eventStatus ?? "") ?? .active
    }
}

extension EventViewModel {
    
    func loadCoverImage(_ done: @escaping (_ img: UIImage?) -> Void) {
        if event.cachedImage != nil {
            done(event.cachedImage)
            return
        }
        
        ImageHelper.loadImage(data: event.image) { [weak self] (image) in
            self?.event.cachedImage = image
            done(image)
        }
    }
    
    func loadOwnerImage(_ done: @escaping (_ img: UIImage?) -> Void) {
        ImageHelper.loadImage(data: event.owner?.profileImage) { [weak self] (image) in
            self?.event.owner?.cachedProfileImage = image
            done(image)
        }
    }
}
