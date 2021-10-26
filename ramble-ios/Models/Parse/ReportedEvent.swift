//
//  ReportEvent.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class ReportedEvent: PFObject, PFSubclassing {
    
    @NSManaged var isEnabled: Bool
    @NSManaged var user: User?
    @NSManaged var event: Event?
    
    // MARK: Functions
    class func parseClassName() -> String {
        return "ReportedEvent"
    }
}

extension ReportedEvent {
    struct Properties {
        static let createdAt = "createdAt"
        static let isEnabled = "isEnabled"
        static let user = "user"
        static let event = "event"
    }
}
