//
//  ReportedUser.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

enum ReportUserType: String {
    case profilePicture, coverPicture
}

class ReportedUser: PFObject, PFSubclassing {
    
    @NSManaged var isEnabled: Bool
    @NSManaged var userReported: User?
    @NSManaged var user: User?
    @NSManaged var reportType: String?
    
    // MARK: Functions
    class func parseClassName() -> String {
        return "ReportedUser"
    }
}

extension ReportedUser {
    struct Properties {
        static let createdAt = "createdAt"
        static let isEnabled = "isEnabled"
        static let userReported = "userReported"
        static let reportType = "reportType"
        static let user = "user"
    }
}
