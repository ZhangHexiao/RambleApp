//
//  Validator.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-17.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

struct Validator {
    
    static func isEmpty(text: String?) -> Bool {
        guard let text = text else { return true }
        return text.trim().isEmpty
    }
    
    static func isValid(email: String) -> String? {
        if email.isEmpty { return RMBError.mandatoryEmail.localizedDescription }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        if !email.matchRegex(emailRegEx) { return RMBError.invalidEmail.localizedDescription }
        return nil
    }
    
    static func isValid(password: String) -> String? {
        if password.isEmpty { return RMBError.mandatoryPassword.localizedDescription  }
        if password.count < 5 { return RMBError.invalidPassword.localizedDescription }
        return nil
    }
    
    static func isValid(username: String) -> String? {
        if username.isEmpty { return RMBError.mandatoryName.localizedDescription }
        if username.count < 2 { return RMBError.invalidName.localizedDescription }
        return nil
    }
}
