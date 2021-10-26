//
//  Notification.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

enum RMBNotificationType: String {
    case invitation // [Friend name] invited to you the event [Event name].
    case friendInterested // [Friend name] is interested by the event [Event name].
    case eventStarting // The event [Event name] is starting in 24 hours.
    case eventCancelled// The event [Event name] has been cancelled.
    case eventCancelledRefunded // The event [Event name] has been cancelled, tickets will be refunded.
    
    // The event [Event name] has been modified: date, time or address.
    case eventModified
    case eventModifiedLocation
    case eventModifiedLocationDate
    case eventModifiedLocationDateTime
    case eventModifiedLocationTime
    case eventModifiedDate
    case eventModifiedDateTime
    case eventModifiedTime
    // This is for buiding the send notification for message system
    case receiveMessage
}

/// PFObject of Notification Model from Parse
class RMBNotification: PFObject, PFSubclassing {
    
    /*
     * Used in queries, we let this flag to modify in backend to not affect associated items
     */
    @NSManaged var isEnabled: Bool
    
    /*
     * Event which notification is from
     */
    @NSManaged var event: Event?

    /*
     * event message
     */
    @NSManaged var message: String?
    
    /*
     * user who sends
     */
    @NSManaged var sender: User?
    
    /*
     * user who received
     */
    @NSManaged var receiver: User?
    
    /*
     * check if user has seen this notification
     */
    @NSManaged var hasSeen: Bool
    
    /*
     * Notification type
     */
    @NSManaged var type: String?
    
    var dateFormatter: String?
    
    // MARK: Functions
    class func parseClassName() -> String {
        return "Notification"
    }
    
    class func safeQuery() -> PFQuery<PFObject>? {
        let query = RMBNotification.query()
        query?.whereKey(Properties.isEnabled, equalTo: true)
        query?.whereKey(Properties.receiver, equalTo: User.current() as Any)

        query?.includeKeys([Properties.event,
                            Properties.sender,
                            Properties.event + "." + Event.Properties.owner])
        return query
    }
}

// MARK: - Properties from parse. To avoid typos
extension RMBNotification {
    struct Properties {
        static let createdAt = "createdAt"
        static let isEnabled = "isEnabled"
        static let event = "event"
        static let message = "message"
        static let sender = "sender"
        static let receiver = "receiver"
        static let hasSeen = "hasSeen"
        static let type = "type"
        static let receiveMessage = "receiveMessage"
    }
}
