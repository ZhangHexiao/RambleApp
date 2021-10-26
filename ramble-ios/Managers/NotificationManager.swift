//
//  NotificationManager.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-22.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

class NotificationManager {
    
    typealias ListNotificationsHandler = ((_ notifications: [RMBNotification], _ error: String?) -> Void)?
    typealias NotificationHandler = ((_ notification: RMBNotification, _ error: String?) -> Void)?
    typealias CountHandler = ((_ count: Int) -> Void)?
    
    func all(_ completion: ListNotificationsHandler = nil) {
        let query = RMBNotification.safeQuery()
        query?.order(byDescending: Event.Properties.createdAt)
        query?.limit = 1000
        query?.findObjectsInBackground(block: { (objects, error) in
            if let err = error {
                completion?([], err.localizedDescription)
                return
            }
            guard let notifications = objects as? [RMBNotification] else {
                completion?([], RMBError.couldntFetchNotification.localizedDescription)
                return
            }
            completion?(notifications, nil)
        })
    }
    func markAsRead(notifications: [RMBNotification], _ completion: SuccessHandler = nil) {
        
        let promises = notifications
                        .filter { !$0.hasSeen }
                        .map { (notif) -> RMBNotification in notif.hasSeen = true; return notif }
                        .map { self.saveInBackgroundAsPromise(notification: $0) }
        
        firstly {
            when(fulfilled: promises)
        }.done { result in
            completion?(true, nil)
        }.catch { error in
            print(error.localizedDescription)
            completion?(true, nil)
        }
    }
    func save(notification: RMBNotification,_ completion: NotificationHandler = nil) {
        notification.saveInBackground(){ (_, error) in
            completion?(notification, error?.localizedDescription)
        }
    }
    private func saveInBackgroundAsPromise(notification: RMBNotification) -> Promise<RMBNotification> {
        return Promise { seal in
            notification.saveInBackground(block: { (_, _) in
                seal.fulfill(notification)
            })
        }
    }
    func countUnreadNotification(_ completion: CountHandler = nil) {
        let query = RMBNotification.safeQuery()
        query?.whereKey(RMBNotification.Properties.hasSeen, equalTo: false)
        query?.countObjectsInBackground(block: { (count, error) in
            completion?(Int(count))
        })
    }
    
    func countUnreadMessage(_ completion: CountHandler = nil) {
        let query = Message.currentUserMessageList()
        query?.whereKey(Message.Properties.unreadFirst, greaterThan: 0)
        query?.countObjectsInBackground(block: { (count, error) in
            completion?(Int(count))
        })
    }
}
