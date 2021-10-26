//
//  NotificationCellViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-22.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

class NotificationCellViewModel {
    
    var notification: RMBNotification
    
    init(notification: RMBNotification) {
        self.notification = notification
    }
    
    var hasSeen: Bool {
        return notification.hasSeen
    }
    
    var dateFormatted: String {
//  ========Modified to get rid of warning===============
//        print("\(notification.createdAt) >>>> \(notification.createdAt?.timeAgoSinceDate(numericDates: true) ??           "Just now".localized)")
        return notification.createdAt?.timeAgoSinceDate(numericDates: true) ?? "Just now".localized
    }
    
    var message: String {
        guard let type = RMBNotificationType(rawValue: notification.type ?? "") else { return ""}
        
        switch type {
        case .eventModifiedTime,
             .eventModifiedDateTime,
             .eventModifiedDate,
             .eventModifiedLocationTime,
             .eventModifiedLocationDateTime,
             .eventModifiedLocationDate,
             .eventModifiedLocation,
             .eventModified,
             .eventCancelled,
             .eventCancelledRefunded,
             .eventStarting:
           return String(format: type.rawValue.localized, notification.event?.name ?? "")
        
        case .friendInterested,
             .invitation:
            return String(format: type.rawValue.localized, notification.sender?.name ?? "", notification.event?.name ?? "")
        case .receiveMessage:
            return type.rawValue.localized
        }
    }
    
    func loadCoverImage(_ done: @escaping (_ img: UIImage?) -> Void) {
        guard let type = RMBNotificationType(rawValue: notification.type ?? "") else { return }
        
        switch type {
        case .invitation, .friendInterested:
            if notification.sender?.cachedProfileImage != nil {
                done(notification.sender?.cachedProfileImage)
                return
            }
            
            ImageHelper.loadImage(data: notification.sender?.profileImage) { [weak self] (image) in
                self?.notification.sender?.cachedProfileImage = image
                done(image)
            }
        case .eventModifiedTime,
             .eventModifiedDateTime,
             .eventModifiedDate,
             .eventModifiedLocationTime,
             .eventModifiedLocationDateTime,
             .eventModifiedLocationDate,
             .eventModifiedLocation,
             .eventModified,
             .eventCancelled,
             .eventCancelledRefunded,
             .eventStarting,
             .receiveMessage:
            if notification.event?.cachedImage != nil {
                done(notification.event?.cachedImage)
                return
            }
            
            ImageHelper.loadImage(data: notification.event?.image) { [weak self] (image) in
                self?.notification.event?.cachedImage = image
                done(image)
            }
        }
    }
}
