//
//  EventsListViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-31.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol EventsListDelegate: Failable, Successable {
    func didChangeTab()
    func didLoadData()
}

enum EventsType {
    case bought, interested, created
}

enum TimeEventType: Int {
    case upcoming, past
}

class EventsListViewModel {
    
    weak var delegate: EventsListDelegate?
    
    var eventsUpcoming: [Event] = []
    var eventsPast: [Event] = []
    
    var eventsType: EventsType = .bought
    var user: User?
    
    var timeEvent: TimeEventType = .upcoming {
        didSet {
            delegate?.didChangeTab()
        }
    }

    var title: String {
        switch eventsType {
        case .bought: return "My Tickets".localized
        case .interested: return "Interested".localized
        case .created: return "Created".localized
        }
    }
    
    init(type: EventsType) {
        eventsType = type
    }
    
    func loadData() {
        switch eventsType {
        case .created:
            loadEventsCreated()
        case .interested:
            loadEventsInterested()
        case .bought:
            loadEventsBought()
        }
    }
    
    private func loadEventsCreated() {
        guard let user = user else { return }

        EventManager().allEventsCreated(by: user) { [weak self] (events, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: false)
                return
            }
            self?.setUpTableViewLists(events: self?.sortByStartDate(events) ?? [])
            self?.delegate?.didLoadData()
        }
    }
    
    private func loadEventsInterested() {
        guard let user = user else { return }
        
        InterestedEventManager().allEventsInterested(by: user) { [weak self] (events, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: false)
                return
            }
            self?.setUpTableViewLists(events: self?.sortByStartDate(events) ?? [])
            self?.delegate?.didLoadData()
        }
        
    }
    
    private func loadEventsBought() {
        guard let user = user else { return }
        
        OrderManager().allEventsBought(by: user) { [weak self] (events, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: false)
                return
            }
            self?.setUpTableViewLists(events: self?.sortByStartDate(events) ?? [])
            self?.delegate?.didLoadData()
        }
    }
    
    private func sortByStartDate(_ events: [Event]) -> [Event] {
        var eventsSorted = events
        eventsSorted.sort { (event1, event2) -> Bool in
            event1.startAt ?? Date() > event2.startAt ?? Date()
        }
        return eventsSorted
    }
    
    func eventDetailsViewModel(at indexPath: IndexPath) -> ExpDetailViewModel {
        var event: Event
        switch timeEvent {
        case .past: event = eventsPast[indexPath.row]
        case .upcoming: event = eventsUpcoming[indexPath.row]
        }
        return ExpDetailViewModel(event: event)
    }
}

// MARK: - TableView
extension EventsListViewModel {
    func numberOfRows(for timeEvent: TimeEventType) -> Int {
        switch timeEvent {
        case .upcoming: return eventsUpcoming.count
        case .past: return eventsPast.count
        }
    }

    private func setUpTableViewLists(events: [Event]) {
        
        eventsUpcoming.removeAll()
        eventsPast.removeAll()
        
        for event in events {
            if event.endAt! > Date() {
                eventsUpcoming.append(event)
            } else {
                eventsPast.append(event)
            }
        }
    }
}
