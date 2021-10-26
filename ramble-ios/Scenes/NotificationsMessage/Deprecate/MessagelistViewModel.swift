//
//  MessagelistViewModel.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-04-13.
//  Copyright © 2020 Ramble Technology. All rights reserved.
//
//import UIKit
//import Foundation
//
//protocol MessagelistDelegate: Loadable {
//}
//
//class MessagelistViewModel {
//    
//    weak var delegate: MessagelistDelegate?
//    var messages: [Message] = []
//    
//    var isEmpty: Bool {
//        return messages.isEmpty
//    }
//    
//    func fetch() {
//        MessagesManager().allMessagelist { [weak self] (messages, error) in
//            if error != nil{
//                //Deal with Error
//            return
//            }
//            self?.messages = self?.setUpMessageList(messages) ?? []
//            self?.delegate?.didLoadData()
//        }
//    }
//    
//    private func setUpMessageList(_ messages: [Message]) -> [Message] {
//        for mes in messages {
//            mes.dateFormatter = mes.createdAt?.fullFormatForNotifications
//        }
//        return orderMessageList(messages: messages)
//    }
//    
//    private func orderMessageList(messages: [Message]) -> [Message] {
//        let array = messages.sorted(by: { $0.createdAt!.compare($1.createdAt!) == .orderedDescending })
//        return array
//    }
//    
//    func markAllAsRead() {
//        NotificationManager().markAsRead(notifications: notifications) { [weak self] (success, error) in
//            self?.delegate?.didLoadData()
//        }
//    }
//    func update(at indexPath: IndexPath) {
//        messags[indexPath.row].hasSeen = true
//        NotificationManager().save(notification: notifications[indexPath.row])
//    }
//}
//
//extension MessagelistViewModel {
//    func numberOfRows() -> Int {
//        return messages.count
//    }
//    
//    func select(at indexPath: IndexPath) -> Message? {
//        let message = messages[indexPath.row]
//        return message
//    }
//    
//    func message(at indexPath: IndexPath) -> MessageCellViewModel {
//        return MessageCellViewModel(message: messages[indexPath.row])
//    }
//}
