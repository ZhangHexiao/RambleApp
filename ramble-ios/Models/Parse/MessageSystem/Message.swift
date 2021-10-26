//
//  Message.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-04-12.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation
import Parse

class Message: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Message"
    }
    
    @NSManaged var isEnabled: Bool
    @NSManaged var isMuteUser: Bool
    @NSManaged var isMuteCreator: Bool
    @NSManaged var firstUser: User?
    @NSManaged var secondUser: User?
    @NSManaged var event: Event?
    @NSManaged var groupId: String?
    @NSManaged var desc: String?
    @NSManaged var lastUser: User?
    @NSManaged var lastPost: Post?
    @NSManaged var unreadFirst: Int
    @NSManaged var unreadSecond: Int
    @NSManaged override var updatedAt: Date?
    
    var cachedImage: UIImage?
    var dateFormatter: String?
    var hasSeen: Bool?
    
    class func safeQuery() -> PFQuery<PFObject>? {
        let query = Message.query()
        query?.whereKey(Message.Properties.isEnabled, equalTo: true)
        return query
    }
    
    class func currentUserMessageList() -> PFQuery<PFObject>? {
        let queryFirstUser = Message.query()?.whereKey(Message.Properties.firstUser, equalTo: User.current() as Any)
         let querySecondUser = Message.query()?.whereKey(Message.Properties.secondUser, equalTo: User.current() as Any)
         let totalQuery = PFQuery.orQuery(withSubqueries: [(queryFirstUser!), querySecondUser!])
         totalQuery.whereKey(Message.Properties.isEnabled, equalTo: true)
         totalQuery.includeKeys([Message.Properties.firstUser, Message.Properties.secondUser, Message.Properties.lastPost, Message.Properties.event])
         totalQuery.order(byAscending: Message.Properties.updatedAt)
         return totalQuery
    }

}
extension Message {
    struct Properties {
        static let isEnabled = "isEnabled"
        static let isMuteUser = "isMuteUser"
        static let isMuteCreator = "isMuteCreator"
        static let firstUser = "firstUser"
        static let secondUser = "secondUser"
        static let groupId = "groupId"
        static let desc = "desc"
        static let lastUser = "lastUser"
        static let lastPost = "lastPost"
        static let unreadFirst = "unreadFirst"
        static let unreadSecond = "unreadSecond"
        static let updatedAt = "updatedAt"
        static let event = "event"
    }
}
