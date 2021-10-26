//
//  TicketManager.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-09.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

class TicketManager {
    
    typealias ListTicketsHandler = ((_ tickets: [Ticket], _ error: String?) -> Void)?

    /**
     Retrieve all tickers from the server giving an event
     ```
     Events and tickets must be from organizer app
     ```
     - parameter event: Event to be queried the tickets
     - parameter completion: list of tickets, error if any
     - returns: void.
     */
    func all(for event: Event, _ completion: ListTicketsHandler = nil) {
        
        let query = Ticket.query()
        query?.includeKey(Ticket.Properties.event)
        query?.whereKey(Ticket.Properties.isEnabled, equalTo: true)
        query?.whereKey(Ticket.Properties.event, equalTo: event)
        query?.limit = 1000
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if let err = error {
                completion?([], err.localizedDescription)
                return
            }
            
            guard let tickets = objects as? [Ticket] else {
                completion?([], RMBError.couldntFetchTicket.localizedDescription)
                return
            }
            
            completion?(tickets, nil)
        })
    }
}
