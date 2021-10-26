//
//  Review.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class Review: PFObject, PFSubclassing {
    /*
     * user who made review
     */
    @NSManaged var user: User?
    
    /*
     * review to which event
     */
    @NSManaged var event: Event?
    /*
     *  comment
     */
    @NSManaged var comment: String?
    /*
     *   star from 1 to 5 for the exprience
     */
    @NSManaged var star: Int
    
    static func parseClassName() -> String {
        return "Review"
    }
    
    class func getCurrentUserReview(event: Event) -> PFQuery<Review>? {
         let query = Review.query()
         query?.includeKey(Review.Properties.event)
         query?.includeKey(Review.Properties.user)
         query?.whereKey(Review.Properties.user, equalTo: User.current() as Any)
         query?.whereKey(Review.Properties.event, equalTo: event)
         return query as? PFQuery<Review>
    }
    
    class func getAllReview(event: Event) -> PFQuery<Review>? {
         let query = Review.query()
         query?.includeKey(Review.Properties.event)
         query?.whereKey(Review.Properties.event, equalTo: event)
         return query as? PFQuery<Review>
    }
    
}

extension Review {
    struct Properties {
        static let user = "user"
        static let event = "event"
        static let comment = "comment"
        static let star = "star"
    }
}
