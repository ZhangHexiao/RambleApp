//
//  Claim.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class Claim: PFObject, PFSubclassing {
    
    /*
     * Used in queries, we let this flag to modify in backend to not affect associated items
     */
    @NSManaged var isEnabled: Bool
    
    /*
     * Event
     */
    @NSManaged var event: Event?
    
    /*
     * claim type
     */
    @NSManaged var claimType: String?
    
    /*
     * user who sends
     */
    @NSManaged var user: User?
    
    /*
     * message
     */
    @NSManaged var message: String?
    
    /*
     * email
     */
    @NSManaged var email: String?
    
    /*
     * phone number
     */
    @NSManaged var phone: String?
    
    // MARK: Functions
    class func parseClassName() -> String {
        return "Claim"
    }
}

// MARK: - Properties from parse. To avoid typos
extension Claim {
    struct Properties {
        static let createdAt = "createdAt"
        static let isEnabled = "isEnabled"
        static let event = "event"
        static let user = "user"
        static let message = "message"
        static let email = "email"
        static let phone = "phone"
    }
}
