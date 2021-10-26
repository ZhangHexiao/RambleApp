//
//  ContactViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-07.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
// swiftlint:disable:next class_delegate_protocol
protocol ContactViewModelDelegate: Failable, Successable {
    
}

enum ContactType: String {
    case contactUs, claimEvent
}

class ContactViewModel {
    
    weak var delegate: ContactViewModelDelegate?
    var eventViewModel: EventViewModel?
    var contactType: ContactType = .contactUs
    
    func inject(type: ContactType, event: EventViewModel? = nil) {
        contactType = type
        eventViewModel = event
    }
    
    // Create a claim into database.
    // Once we create it. It triggers a function on server side where sends the email.
    func send(email: String?, phone: String?, text: String?) {
        if let emailError = Validator.isValid(email: email ?? "") {
            delegate?.didFail(error: emailError, removeFromTop: false)
            return
        }
        
        if Validator.isEmpty(text: phone) {
            delegate?.didFail(error: RMBError.emptyPhoneNumber.localizedDescription, removeFromTop: false)
            return
        }
        
        if Validator.isEmpty(text: text) {
            delegate?.didFail(error: RMBError.emptyMessage.localizedDescription, removeFromTop: false)
            return
        }
        
        let claim = Claim()
        claim.email = email
        claim.phone = phone
        claim.message = text
        claim.claimType = contactType.rawValue
        claim.event = eventViewModel?.event
        claim.user = User.current()
        
        ClaimManager().save(claim: claim) { [weak self] (claim, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: false)
                return
            }
            self?.delegate?.didSuccess(msg: "Your request has been sent to the admin team. They will contact you as soon as they can.".localized, removeFromTop: true)
        }
    }
}
