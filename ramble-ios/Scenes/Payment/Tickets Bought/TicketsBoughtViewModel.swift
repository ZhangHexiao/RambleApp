//
//  TicketBoughtViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-15.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

class TicketsBoughtViewModel {
    
    var event: Event
    var tickets: [TicketBoughtViewModel]
    
    var numberOfPages = 0
    var currentPage = 0.0
    
    var eventView: EventViewModel {
        return EventViewModel(event: event)
    }
    
    init(event: Event, tickets: [TicketBoughtViewModel]) {
        self.event = event
        self.tickets = tickets
        numberOfPages = tickets.count
    }
    
    init(event: Event, ticketsBought: [TicketBought]) {
        self.event = event
        self.tickets = ticketsBought.map { TicketBoughtViewModel(ticketBought: $0) }
        numberOfPages = tickets.count
    }
}
