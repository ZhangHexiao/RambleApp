//
//  InterestedEvents.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2018-10-01.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class InterestedEvent: PFObject, PFSubclassing {
    
    @NSManaged var isEnabled: Bool
    @NSManaged var user: User?
    @NSManaged var event: Event?
    
    // MARK: Functions
    class func parseClassName() -> String {
        return "InterestedEvent"
    }
    
    class func safeQuery() -> PFQuery<PFObject>? {
        let query = InterestedEvent.query()
        query?.whereKey(Properties.isEnabled, equalTo: true)
        query?.includeKeys([InterestedEvent.Properties.event,
                            InterestedEvent.Properties.user,
                            "\(InterestedEvent.Properties.event).\(Event.Properties.owner)"])
        return query
    }
}

extension InterestedEvent {
    struct Properties {
        static let createdAt = "createdAt"
        static let isEnabled = "isEnabled"
        static let user = "user"
        static let event = "event"
    }
}
