//
//  User.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

enum UserType: String {
    case customer, organizer
}

enum UserAuthType: String {
    case email, facebook
}

class User: PFUser {
    
    /*
     * Used in queries, we let this flag to modify in backend to not affect associated items
     */
    @NSManaged var isEnabled: Bool
    
    /*
     * UserType enum: customer or organizer
     */
    @NSManaged var userType: String?
    
    /*
     * User name
     */
    @NSManaged var name: String?
    
    /*
     * User last name
     */
    @NSManaged var lastName: String?
    
    /*
     * Organization name (from organizer app)
     */
    @NSManaged var organizationName: String?

    /*
     * PFFile user or organization image
     */
    @NSManaged var profileImage: PFFileObject?
    
    /*
     * PFFile Cover image
     */
    @NSManaged var coverImage: PFFileObject?

    /*
     * PFGeoPoint Location of user
     */
    @NSManaged var location: PFGeoPoint?
    
    /*
     * facebookId from user's facebook profile. Used to authenticate and retrieve data from user
     */
    @NSManaged var facebookId: String?
    
    /*
     * AuthType that user signed up:
     */
    @NSManaged var authType: String?
    
    /*
     * Transit number, used in organizer app
     */
    @NSManaged var bankTransitNumber: Int
    
    /*
     * Institution number, used in organizer app
     */
    @NSManaged var bankInstitutionNumber: Int
    
    /*
     * Account number, used in organizer app
     */
    @NSManaged var bankAccountNumber: Int
    
    /*
     * bank name, used in organizer app
     */
    @NSManaged var bankCompanyName: String?
    
    /*
     * Bank address, used in organizer app
     */
    @NSManaged var bankCompanyAddress: String?
    /// Knows if the user has a verified account
    @NSManaged var isVerifiedAccount: Bool
    /*
     * Bank address, used in organizer app
     */
    @NSManaged var stpCustomerId: String?
    /*
     * StripeAccount to received money
     */
    @NSManaged var stpPaymentMethodId: String?

    /*
     * Simple cache system. See ImageHelper for a more robust cache.
     */
    var cachedProfileImage: UIImage?
}

extension User {
    struct Properties {
        static let email = "email"
        static let isEnabled = "isEnabled"
        static let userType = "userType"
        static let name = "name"
        static let lastName = "lastName"
        static let organizationName = "organizationName"
        static let profileImage  = "profileImage"
        static let coverImage = "coverImage"
        static let location = "location"
        static let facebookId = "facebookId"
        static let bankTransitNumber = "bankTransitNumber"
        static let bankInstitutionNumber = "bankInstitutionNumber"
        static let bankAccountNumber = "bankAccountNumber"
        static let bankCompanyName = "bankCompanyName"
        static let bankCompanyAddress = "bankCompanyAddress"
        static let stpCustomerId = "stpCustomerId"
        static let authType = "authType"
        static let isVerifiedAccount = "isVerifiedAccount"
        static let stpPaymentMethodId = "stpPaymentMethodId"
    }
}
