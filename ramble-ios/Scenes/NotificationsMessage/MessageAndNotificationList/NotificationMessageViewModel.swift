//
//  NotificationViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technology Inc. on 2018-10-22.
//  Hexiao Zhang
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse
import ParseLiveQuery

protocol NotificationDelegate: Loadable {
}

class NotiMesViewModel {
    
    weak var delegateNoti: NotificationDelegate?
    var notifications: [RMBNotification] = []
    var messages: [Message] = []
    
    var isNotiEmpty: Bool {
        return notifications.isEmpty
    }
    var isMessageEmpty: Bool {
        return messages.isEmpty
    }
    
    //Build the livequery, and set the livequery at Function "allMessagelist"
    //so the first time load the message we can set the livequery
    
    var totalQuery: PFQuery<Message>? {
        return Message.currentUserMessageList() as? PFQuery<Message>
    }

    var connected: Bool?
    
    func disconnectLiveQuery() {
        MockSocket.shared.disconnectMessageList(with: self.totalQuery!)
    }
    
    func subscribeToUpdates() {
        MockSocket.shared.connectMessageList(with: self.totalQuery!).handleEvent{ query, event in
                    self.fetchMessage()}
        }
//===============================================
    
    func fetchNotification() {
        NotificationManager().all { [weak self] (notifications, error) in
            self?.notifications = self?.setUpNotificationList(notifications) ?? []
            self?.delegateNoti?.didLoadData()
        }
    }
   
    func fetchMessage() {
        MessagesManager().allMessagelist { [weak self] (messages, error) in
            if error != nil{
                //Deal with Error
            return
            }
            self?.messages = self?.setUpMessageList(messages) ?? []
            self?.delegateNoti?.didLoadData()
        }
    }

    private func setUpNotificationList(_ notifications: [RMBNotification]) -> [RMBNotification] {
        for notif in notifications {
            notif.dateFormatter = notif.createdAt?.fullFormatForNotifications
        }
        return orderNotificationList(notifications: notifications)
    }
    
    private func setUpMessageList(_ messages: [Message]) -> [Message] {
        for mes in messages {
            mes.dateFormatter = mes.createdAt?.fullFormatForNotifications
        }
        return orderMessageList(messages: messages)
    }
    
    private func orderNotificationList(notifications: [RMBNotification]) -> [RMBNotification] {
        let array = notifications.sorted(by: { $0.createdAt!.compare($1.createdAt!) == .orderedDescending })
        return array
    }
 
    private func orderMessageList(messages: [Message]) -> [Message] {
        let array = messages.sorted(by: { $0.lastPost?.createdAt!.compare(($1.lastPost?.createdAt)!) == .orderedDescending })
        return array
    }
    
    func markAllAsRead() {
        NotificationManager().markAsRead(notifications: notifications) { [weak self] (success, error) in
            self?.delegateNoti?.didLoadData()
        }
    }
    
    func update(at indexPath: IndexPath) {
        notifications[indexPath.row].hasSeen = true
        NotificationManager().save(notification: notifications[indexPath.row])
    }
}

extension NotiMesViewModel {
    func numberOfRows(type: String) -> Int {
        if type == "notification"
        {return notifications.count} else{
            return messages.count
        }
    }
    
    func selectNotificaiton(at indexPath: IndexPath) -> ExpDetailViewModel? {
        if let event = notifications[indexPath.row].event {
            update(at: indexPath)
            return ExpDetailViewModel(event: event)
        }
        return nil
    }
    
    func selectMessage(at indexPath: IndexPath) -> Message? {
        let message = messages[indexPath.row]
        return message
    }
    
    func notification(at indexPath: IndexPath) -> NotificationCellViewModel {
        return NotificationCellViewModel(notification: notifications[indexPath.row])
    }
    func message(at indexPath: IndexPath) -> MessageCellViewModel {
        return MessageCellViewModel(message: messages[indexPath.row])
    }
}
