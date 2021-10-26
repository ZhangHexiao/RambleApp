//
//  MessageManager.swift
//  ChatExample
//
//  Created by Hexiao Zhang on 2020-04-13.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation
import Parse

class MessagesManager {
    
    typealias ListMessagesHandler = ((_ messages: [Message], _ error: String?) -> Void)?
    typealias MessageHandler = ((_ message: Message, _ error: String?) -> Void)?
    typealias CountHandler = ((_ count: Int) -> Void)?
    var totalQuery: PFQuery<Message>? {
        return Message.currentUserMessageList() as? PFQuery<Message>
    }
   
    func allMessagelist(_ completion: ListMessagesHandler = nil) {
        self.totalQuery?.findObjectsInBackground(block: { (objects, error) in
            if let err = error {
                completion?([], err.localizedDescription)
                return
            }
            guard let messages = objects else {
                completion?([], nil)
                return
            }
            completion?(messages, nil)
        })
    }
    
    func save(message: Message, _ completion: MessageHandler = nil) {
        message.saveInBackground(){(_, error) in
            completion?(message, error?.localizedDescription)
        }
    }
    
    func getGourpId(_ userFirst: String, _ userSecond: String) -> String {
        let userIds = [userFirst, userSecond]
        
        let sorted = userIds.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        let joined = sorted.joined(separator: "")
        
        return joined
    }
    //FirstUser should alwayse be User, and SeconUser should be Creator
    func createMessageItem(event: Event, _ completion: ListMessagesHandler = nil) {
        let query = Message.query()?.whereKey(Message.Properties.firstUser, equalTo: User.current()!)
        query?.whereKey(Message.Properties.event, equalTo: event)
        query?.findObjectsInBackground( block: {(objects, error) in
            if error == nil {
                if objects!.count == 0 {
                    var messages:[Message] = []
                    let message = Message()
                    message.firstUser = User.current()
                    message.secondUser = event.owner
                    message.unreadFirst = 0
                    message.unreadSecond = 0
                    message.isEnabled = true
                    message.isMuteUser = false
                    message.event = event
                    messages.append(message)
                    completion?(messages, nil)
                } else{
                    completion?(objects as! [Message], nil)
                }
            } else {
                completion?([], RMBError.couldntFetchChat.localizedDescription)
            }
        })
    }
    //===========Unused Function================
    //       private func saveInBackgroundAsPromise(notification: RMBNotification) -> Promise<RMBNotification> {
    //           return Promise { seal in
    //               notification.saveInBackground(block: { (_, _) in
    //                   seal.fulfill(notification)
    //               })
    //           }
    //       }
    //
    //       func countUnread(_ completion: CountHandler = nil) {
    //           let query = RMBNotification.safeQuery()
    //           query?.whereKey(RMBNotification.Properties.hasSeen, equalTo: false)
    //           query?.countObjectsInBackground(block: { (count, error) in
    //               completion?(Int(count))
    //           })
    //       }
    
    //     func startPrivateChat(user1: User, user2: User) -> String {
    //        let id1 = user1.objectId
    //        let id2 = user2.objectId
    //
    //        let groupId = (id1 < id2) ? "\(id1)\(id2)" : "\(id2)\(id1)"
    //
    //        createMessageItem(user1, groupId: groupId, description: user2[PF_USER_FULLNAME] as! String)
    //
    //        return groupId
    //    }
    //
    //========================================
}
