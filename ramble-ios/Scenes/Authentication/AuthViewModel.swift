//
//  AuthViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-17.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol AuthViewModelDelegate: class {
    func didSuccess(msg: String)
    func didFail(error: String)
    func didConnect(type: AuthTypeRoute)
}

enum AuthTypeRoute {
    case accountSetup
    case main
}

class AuthViewModel {
    
    weak var delegate: AuthViewModelDelegate?

    func actionLogin(email: String, password: String) {
        AuthManager().login(email: email, password: password) { [weak self] error in
            if let err = error {
                self?.delegate?.didFail(error: err)
            } else {
                self?.delegate?.didConnect(type: UserManager.hasUserCompletedProfile() ? .main : .accountSetup )
            }
        }
    }

    func actionSignup(email: String, password: String) {
        AuthManager().signup(email: email, password: password) { [weak self] error in
            if let err = error {
                self?.delegate?.didFail(error: err)
            } else {
                self?.delegate?.didConnect(type: .accountSetup)
            }
        }
    }

    func actionFacebook() {
        AuthManager().connectFacebook { [weak self] (error) in
            if let err = error {
                self?.delegate?.didFail(error: err)
            } else {
                GRNNotif.guestLoggedIn.postNotif(nil)
                self?.delegate?.didConnect(type: UserManager.hasUserCompletedProfile() ? .main : .accountSetup)
            }
        }
    }
}

extension AuthViewModel {
    func forgotPassword(email: String) {
        if validate(email: email) {
            return
        }
        AuthManager().resetPassword(given: email) { [weak self] (error) in
            if let err = error {
                self?.delegate?.didFail(error: err)
                return
            }
            self?.delegate?.didSuccess(msg: "An email has been sent to resent password.".localized)
        }
    }
}

// MARK: - Validations
extension AuthViewModel {
    func validate(email: String) -> Bool {
        if let error = Validator.isValid(email: email) {
            delegate?.didFail(error: error)
            return true
        }
        return false
    }
    
    func validate(password: String) -> Bool {
        if let error = Validator.isValid(password: password) {
            delegate?.didFail(error: error)
            return true
        }
        return false
    }
}
