//
//  RMBError.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-06.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

enum RMBError: Error {
    case unknown
    
    // Swiflint false positive
    // swiftlint:disable:next identifier_name
    case custom(error: String)
    
    // User
    case mandatoryEmail
    case invalidEmail
    case mandatoryPassword
    case invalidPassword
    case mandatoryName
    case invalidName
    case wrongUserType
    case expiredSession
    

    // Facebook Errors
    case invalidFacebookId
    case gettingFriends
    case linkFacebook
    
    case reportedTooManyTimes
    case reportedEventTooManyTimes
    case couldntGetTaxes
    case couldntBuyTickets
    
    case hasBeenInterested
    case couldntFetchEvent
    case couldntFetchTicket
    case couldntFetchNotification
    
    // Event creation errors
    
    case invalidEventName
    case invalidEventImage
    case invalidEventCategory
    case invalidEventStartDate
    case invalidEventEndDate
    case invalidStartEventAfterEndDate
    case invalidEndEventBeforeStartDate
    case invalidEventLocation
    case invalidEventDescription
    case invalidEventWebLink
    
    case selectDateCantSelectPastDate
    case locationCantRetrieceUsersLocation
    case cantFetchData
    
    case selectTicket
    case eventBlocked
    case allowUserLocation
    case cantChangeFacebookPassword
    
    // Reset password
    case emptyFields
    case oldPasswordEmpty
    case newPasswordEmpty
    case newPasswordsDontMatch
    
    case emptyCreditCard
    case emptyPhoneNumber
    case emptyMessage
    case emptySelectFriend
    case expiredDate
    
    // Chatting system
    case couldntFetchChat
    case couldntSendMessage
    
    // Save review error
    case couldntSavePromise
}

extension RMBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Something went wrong".localized
        case .custom(error: let error):
            return error
        case .mandatoryEmail:
            return "Email is mandatory".localized
        case .invalidEmail:
            return "Please enter a valid email address".localized
        case .mandatoryPassword:
            return "Please enter your password".localized
        case .invalidPassword:
            return "Invalid Password".localized
        case .mandatoryName:
            return "Field is mandatory".localized
        case .invalidName:
            return "Invalid field".localized
        case .wrongUserType:
            return "User is wrong".localized
        case .invalidFacebookId:
            return "There is no Facebook account linked.".localized
        case .gettingFriends:
            return "Error getting friends".localized
        case .linkFacebook:
            return "Something went wrong connecting with facebook".localized
        case .reportedTooManyTimes:
            return "You have reported this user before.".localized
        case .couldntGetTaxes:
            return "Couldn't get tax".localized
        case .couldntBuyTickets:
            return "Couldn't buy tickets".localized
        case .expiredSession:
            return "Session has expired".localized
        case .hasBeenInterested:
            return "Can't delete because someone is already interested in this event".localized
        case .couldntFetchEvent:
            return "Couldn't fetch events".localized
        case .reportedEventTooManyTimes:
            return "You have reported this event before.".localized
        case .couldntFetchTicket:
            return "Couldn't fetch tickets".localized
        case .couldntFetchNotification:
            return "Couldn't fetch notifications".localized
        case .invalidEventName:
            return "Event title is empty/invalid.".localized
        case .invalidEventImage:
            return "Please add an image.".localized
        case .invalidEventCategory:
            return "Please select a category.".localized
        case .invalidEventStartDate:
            return "Please select a start date.".localized
        case .invalidEventEndDate:
            return "Please select an end date.".localized
        case .invalidStartEventAfterEndDate:
            return "Start date can't be after end date".localized
        case .invalidEndEventBeforeStartDate:
            return "End date can't be before start date".localized
        case .invalidEventLocation:
            return "Please select the location".localized
        case .invalidEventDescription:
            return "Please add a description".localized
        case .invalidEventWebLink:
            return "Web must start with http://".localized
        case .selectDateCantSelectPastDate:
            return "Can't select past date".localized
        case .locationCantRetrieceUsersLocation:
            return "Couldn't retrieve user's location".localized
        case .cantFetchData:
            return "Couldn't fetch data, try again later".localized
        case .selectTicket:
            return "Please select a ticket".localized
        case .eventBlocked:
            return "This event has been blocked for inappropriate content. Come back later".localized
        case .allowUserLocation:
            return "Please allow user location".localized
        case .cantChangeFacebookPassword:
            return "You can't change password for your Facebook account".localized
        case .emptyFields:
            return "Values can't be empty".localized
        case .oldPasswordEmpty:
            return "Please enter old passord".localized
        case .newPasswordEmpty:
            return "Please enter new password".localized
        case .newPasswordsDontMatch:
            return "New password entries don't match".localized
        case .emptyCreditCard:
            return "Please add a credit card".localized
        case .emptyPhoneNumber:
            return "Please enter phone number".localized
        case .emptyMessage:
            return "Please type message".localized
        case .emptySelectFriend:
            return "Couldn't invite friend".localized
        case .expiredDate:
            return "Expiration Date is invalid".localized
        case .couldntFetchChat:
                return "Couldn't fetch chat messages".localized
        case .couldntSendMessage:
                return "Couldn't send chat messages".localized
        case .couldntSavePromise:
                return "Couldn't save your review".localized
        }
    }
}
