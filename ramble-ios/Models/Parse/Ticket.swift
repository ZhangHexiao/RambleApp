//
//  Ticket.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class Ticket: PFObject, PFSubclassing {
    
    /*
     * Used in queries, we let this flag to modify in backend to not affect associated items
     */
    @NSManaged var isEnabled: Bool
    
    /*
     * Ticket name
     */
    @NSManaged var name: String?
    
    /*
     * Ticket description
     */
    @NSManaged var desc: String?
    
    /*
     * Event which ticket is associated
     */
    @NSManaged var event: Event?
    
    /*
     * Number of tickets still available
     */
    @NSManaged var availableTickets: Int
    
    /*
     * Number of tickets sold. Value updated from server side.
     */
    @NSManaged var ticketsSold: Int
    
    /*
     * Price of the ticket
     */
    @NSManaged var unitPrice: Int
    
    /* Date when the section is starting.
     */
    @NSManaged var startAt: Date?
    
    /*
     * Date when the section is ending.
     */
    @NSManaged var endAt: Date?
    
    // MARK: Functions
    class func parseClassName() -> String {
        return "Ticket"
    }
}

// MARK: - Properties from parse of this event. To avoid typos
extension Ticket {
    struct Properties {
        static let createdAt = "createdAt"
        static let startAt = "startAt"
        static let endAt = "endAt"
        static let isEnabled = "isEnabled"
        static let name = "name"
        static let desc = "desc"
        static let unitPrice = "unitPrice"
        static let availableTickets = "availableTickets"
        static let event = "event"
        static let ticketsSold = "ticketsSold"
    }
}
