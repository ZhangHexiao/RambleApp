//
//  TicketBought.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class TicketBought: PFObject, PFSubclassing {
    
    /*
     * Used in queries, we let this flag to modify in backend to not affect associated items
     */
    @NSManaged var isEnabled: Bool
    
    /*
     * Ticket bought
     */
    @NSManaged var ticket: Ticket?
    
    /*
     * Event which ticket is from
     */
    @NSManaged var event: Event?
    
    /*
     * User who bought the ticket
     */
    @NSManaged var user: User?
    
    /*
     * Order which is from
     */
    @NSManaged var order: Order?
    
    /*
     * Flag to indicate if ticket has been scanned
     */
    @NSManaged var isScanned: Bool
 
    // MARK: Functions
    class func parseClassName() -> String {
        return "TicketBought"
    }
}

// MARK: - Properties from parse of this event. To avoid typos
extension TicketBought {
    struct Properties {
        static let createdAt = "createdAt"
        static let isEnabled = "isEnabled"
        static let ticket = "ticket"
        static let user = "user"
        static let event = "event"
        static let order = "order"
        static let isScanned = "isScanned"
    }
}
