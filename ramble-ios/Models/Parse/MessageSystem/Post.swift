//
//  Post.swift
//  ramble-ios
//
//  Created by Hexio Zhang Ramble Tecnology Inc. on 2018-08-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class Post: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Post"
    }
    @NSManaged var isEnabled: Bool
    @NSManaged var source: User?
    @NSManaged var target: User?
    @NSManaged var content: String?
    @NSManaged var groupId: String?
    @NSManaged var messageGroup: Message?
    
    class func safeQuery() -> PFQuery<PFObject>? {
        let query = Post.query()
        query?.includeKey(Post.Properties.source)
        query?.includeKey(Post.Properties.target)
        query?.whereKey(Post.Properties.isEnabled, equalTo: true)
        return query
    }
    
    class func chatQuery(message: Message) -> PFQuery<Post>? {
        let query = Post.query()
        query?.includeKey(Post.Properties.source)
        query?.includeKey(Post.Properties.target)
        query?.whereKey(Post.Properties.isEnabled, equalTo: true)
        
        query?.whereKey(Post.Properties.messageGroup, equalTo: message)
        query?.order(byDescending: "createdAt")
        query?.limit = 6
        return query as? PFQuery<Post>
    }

}
extension Post {
    struct Properties {
        static let isEnabled = "isEnabled"
        static let createdAt = "createdAt"
        static let source = "source"
        static let target = "target"
        static let content = "content"
        static let groupId = "groupId"
        static let messageGroup = "messageGroup"
    }
}
