//
//  PushNotificationManager.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

class PushNotificationManager {
    
    func sendPushNotification(sender: User?, receiver: User?, event: Event, type: RMBNotificationType) {
        
        guard let receiverId = receiver?.objectId else { return }
        
        var locArgs: [String]
        
        switch type {
        case .eventStarting,
             .eventModified,
             .eventModifiedLocation,
             .eventModifiedLocationDate,
             .eventModifiedLocationDateTime,
             .eventModifiedLocationTime,
             .eventModifiedDateTime,
             .eventModifiedDate,
             .eventModifiedTime,
             .eventCancelled,
             .eventCancelledRefunded:
            locArgs = [event.name ?? ""]
        
        case .friendInterested,
             .invitation:
            locArgs = [sender?.name ?? "A friend", event.name ?? ""]
            
        case .receiveMessage:
            locArgs = [event.name ?? ""]
        }
        
        let params: [String: Any] = ["receiverId": receiverId,
                                     "type": type.rawValue,
                                     "locKey": type.rawValue,
                                     "eventId": event.objectId ?? "",
                                     "senderId": sender?.objectId ?? "",
                                     "locArgs": locArgs ]
        
        PFCloud.callFunction(inBackground: "sendPushNotification", withParameters: params) { _, error in
            print("SENT PUSH NOTIFICATION: \(error?.localizedDescription ?? "SUCCESS")")
        }
    }
    
//    func sendPushNotificationToFriends(for event: Event) {
//        
//        let params: [String: Any] = ["eventId": event.objectId ?? "",
//                                     "eventName": event.name ?? ""]
//        
//        PFCloud.callFunction(inBackground: "friendInterestedInEvent", withParameters: params) { _, error in
//            print("friendInterestedInEvent: \(error?.localizedDescription ?? "SUCCESS")")
//        }
//    }
}
