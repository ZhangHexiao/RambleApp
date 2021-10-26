//
//  ExpDetailViewModel.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-10.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol ExpDetailViewModelDelegate: Failable, Successable {
    func didUpdateImage()
    func didFetchAdditionalItems()
}

enum ExpDetailListCell {
    case cover, hostInfo, details, cancelled, map, expSummary
}

class ExpDetailViewModel {
    
    var eventViewModel: EventViewModel
    
    weak var delegate: ExpDetailViewModelDelegate?
    var tableViewList: [ExpDetailListCell] = []
    var expCity: String?
    
    var navTitle: String {
        return "Event Details".localized
    }
    
    var interestedIcon: UIImage {
        if eventViewModel.hasBoughtTickets {
            return #imageLiteral(resourceName: "ic_interest")
        }
        return eventViewModel.hasBeenInterested ? #imageLiteral(resourceName: "ic_interest") : #imageLiteral(resourceName: "ic_like")
    }
    
    var newEventViewModel: NewEventViewModel {
        return NewEventViewModel(event: eventViewModel.event, eventType: .edit)
    }
    var newDulplicateEventViewModel: NewEventViewModel {
        return NewEventViewModel(event: eventViewModel.event, eventType: .duplicate)
    }
    
    var getTicketsViewModel: GetTicketsViewModel {
        return GetTicketsViewModel(event: eventViewModel.event)
    }
    
    var ticketsBoughtViewModel: TicketsBoughtViewModel? {
        guard let tickets = eventViewModel.ticketsBoughtViewModel else { return nil }
        return TicketsBoughtViewModel(event: eventViewModel.event, tickets: tickets)
    }
    
    var hasFriendsInterested: Bool {
        return !eventViewModel.friendsViewModel.friends.isEmpty
    }
    
    init(event: Event) {
        eventViewModel = EventViewModel(event: event)
        loadImages()
        getExpLocation()
        updateTableViewList()
        fetchEvent()
    }
    
    func fetchEvent() {
        EventManager().fetchInfo(from: eventViewModel.event) { [weak self] (eventFetched, error) in
            if let err = error {
                if User.current() != nil {
                    self?.delegate?.didFail(error: err, removeFromTop: false)
                }
                return
            }
            
            if eventFetched != nil {
                self?.eventViewModel.inject(event: eventFetched!)
            }
            self?.updateTableViewList()
            self?.delegate?.didFetchAdditionalItems()
        }
    }
    
    private func loadImages() {
        eventViewModel.loadCoverImage { [weak self] (coverImage) in
            self?.delegate?.didUpdateImage()
        }
        
        eventViewModel.loadOwnerImage {  [weak self] (ownerImage) in
            self?.delegate?.didUpdateImage()
        }
    }
    
    func showBottomView() -> Bool {
        switch eventViewModel.status {
        case .blocked, .cancelled, .reported:
             return false
        case .active:
// Even if the experience ends, user still have access to review and rate it.
//            if let endAt = eventViewModel.endAt, endAt < Date() {
//                return false
//            }
            return true
        }
    }
    
    func showNavItem() -> Bool {
        return showBottomView()
    }
    
    func showGetTicketsButton() -> Bool {
//        if User.current() == nil { return false }
        return eventViewModel.hasBadge || eventViewModel.ticketsWebLinkURL != nil
    }
    
    func report() {
        ReportEventManager().createReport(event: eventViewModel.event) { [weak self] (reported, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: false)
                return
            }
            self?.delegate?.didSuccess(msg: "Event reported".localized, removeFromTop: false)
        }
    }

    func cancel() {
        EventManager().cancel(event: eventViewModel.event) { [weak self] (event, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: false)
            } else {
                if let event = event {
                    self?.eventViewModel.inject(event: event)
                    self?.updateTableViewList()
                    self?.delegate?.didSuccess(msg: "Event cancelled.", removeFromTop: false)
                    self?.delegate?.didFetchAdditionalItems()
                }
                
            }
        }
    }
    
    func delete() {
        EventManager().delete(event: eventViewModel.event) { [weak self] (error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: true)
            } else {
                self?.delegate?.didSuccess(msg: "Event deleted.", removeFromTop: true)
            }
        }
    }
}

extension ExpDetailViewModel {
    func actionInterested() {
        
        // Don't do anything
        if eventViewModel.isMine || eventViewModel.hasBoughtTickets {
            delegate?.didFetchAdditionalItems()
            return
        }
        
        InterestedEventManager().toggleInterestedEvent(event: eventViewModel.event) { [weak self] (interestedEvent, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: false)
                return
            }
            
            self?.eventViewModel.event.hasEventBeenInterested = interestedEvent != nil
            self?.delegate?.didFetchAdditionalItems()
        }
    }
    
    func getExpLocation() {
        let placesService = LocationService()
        placesService.getResetLocation(coordinateReset: eventViewModel.coordinate) { [weak self] (location) in
            guard let location = location else {
                self?.expCity = "Canada"
                return
            }
            self?.expCity = location.getCity().localized
        }
    }
}

// MARK: - Tableview methods related
extension ExpDetailViewModel {
    private func updateTableViewList() {
        tableViewList.removeAll()
        
        tableViewList.append(.cover)
       
        if eventViewModel.status == .cancelled {
            tableViewList.append(.cancelled)
        }
        tableViewList.append(.expSummary)
        tableViewList.append(.hostInfo)
        tableViewList.append(.details)
        tableViewList.append(.map)
    }
    
    func numberOfRows(for section: Int) -> Int {
        return tableViewList.count
    }
    
    func typeCell(for indexPath: IndexPath) -> ExpDetailListCell {
        return tableViewList[indexPath.row]
    }
}
