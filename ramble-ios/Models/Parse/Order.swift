//
//  Order.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

enum OrderStatus: String {
    case pending, success, cancel, refund
}

class Order: PFObject, PFSubclassing {
    
    /*
     * Used in queries, we let this flag to modify in backend to not affect associated items
     */
    @NSManaged var isEnabled: Bool
    
    /*
     * Event which order is from
     */
    @NSManaged var event: Event?
    
    /*
     * User who bought the tickets
     */
    @NSManaged var user: User?
    
    /*
     * Identifier from Stripe service
     */
    @NSManaged var stpChargeId: String?
    
    /*
     * Status of the order: Success, Cancelled, Refunded
     */
    @NSManaged var orderStatus: String?
    
    /*
     * Total taxes of this order.
     */
    @NSManaged var taxes: Int
    
    /*
     * SubTotal of this order
     */
    @NSManaged var subTotal: Int
    
    // MARK: Functions
    class func parseClassName() -> String {
        return "Order"
    }
    
    class func safeQuery() -> PFQuery<PFObject>? {
        let query = Order.query()
        query?.whereKey(Properties.isEnabled, equalTo: true)
        
        query?.includeKeys([Properties.event,
                            Properties.user,
                            Properties.event + "." + Event.Properties.owner])
        return query
    }
}

// MARK: - Properties from parse. To avoid typos
extension Order {
    struct Properties {
        static let createdAt = "createdAt"
        static let isEnabled = "isEnabled"
        static let user = "user"
        static let event = "event"
        static let stpChargeId = "stpChargeId"
        static let orderStatus = "orderStatus"
        static let taxes = "taxes"
        static let subTotal = "subTotal"
    }
}
