//
//  AuthManager.swift
//  ramble-ios
//
//  Created by Hexiao Zhang, Ramble Technologies Inc. on 2018-08-28.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

class AuthManager {
    /**
     Signup method.
     - parameter email: String.
     - parameter password: String
     - parameter completion: Completion handler error
     - returns: void.
     */
    func signup(email: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        let user = User()
        user.username = email
        user.email = email
        user.password = password
        user.isEnabled = true
        user.isVerifiedAccount = false
        user.userType = UserType.customer.rawValue
        user.authType = UserAuthType.email.rawValue
        
        user.signUpInBackground { _, error in
            if error != nil {
                completion(error?.localizedDescription)
            } else {
                Installation.current()?.linkUser()
                UserManager().getCurrentLocation()
                completion(error?.localizedDescription)
            }
        }
    }
    
    /**
     Login method.
     ```
     Check if login is enabled for customer app first
     ```
     - parameter email: String.
     - parameter password: String
     - parameter completion: Completion handler error
     - returns: void.
     */
    func login(email: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        
        firstly {
            findUserType(email)
        }.map { userType in
            if userType == UserType.organizer {
                throw RMBError.wrongUserType
            }
        }.then {
            self.login(email: email, password: password)
        }.done {
            Installation.current()?.linkUser()
            UserManager().getCurrentLocation()
            completion(nil)
        }.catch { (error) in
            print(error.localizedDescription)
            completion(error.localizedDescription)
            return
        }
    }
    
    /**
     Logout method.
     ```
     Remove user from installation
     ```
     - parameter completion: Completion handler void
     - returns: void.
     */
    class func logout(_ completion:(() -> Void)? = nil) {
        Installation.current()?.unlinkUser()
        User.logOutInBackground { (error) in
            print(error?.localizedDescription ?? "Logout successfully")
            completion?()
        }
    }
    
    /**
     Connect facebook for authentication.
     - parameter completion: Completion handler error
     - returns: void.
     */
    func connectFacebook( _ completion: @escaping (_ error: String?) -> Void) {
        firstly {
            FacebookManager.shared.connectFacebook()
        }.done {
            UserManager().getCurrentLocation()
            completion(nil)
        }.catch { (error) in
            print(error.localizedDescription)
            completion(error.localizedDescription)
            return
        }
    }
    
    /**
        Parse doesn't have a function to change password. So we work around that login and logout user with different password injected in the User.password field
     */
    func changePassword(email: String, oldPassword: String, newPassword: String, _ completion: @escaping (_ error: String?) -> Void) {
        
        firstly {
            self.login(email: email, password: oldPassword)
        }.get {
            User.current()?.password = newPassword
        }.then {
            self.save()
        }.then {
            self.logout()
        }.then {
            self.login(email: email, password: newPassword)
        }.done {
            completion(nil)
        }.catch { (error) in
            print(error.localizedDescription)
            completion(error.localizedDescription)
            return
        }
    }
}

extension AuthManager {
    func resetPassword(given email: String, _ completion: @escaping (_ error: String?) -> Void) {
        User.requestPasswordResetForEmail(inBackground: email) { _, error in
            completion(error?.localizedDescription)
        }
    }
}

extension AuthManager {
    
    private func login(email: String, password: String) -> Promise<Void> {
        return Promise { seal in
            PFUser.logInWithUsername(inBackground: email, password: password) { (_, error) in
                if let err = error {
                    seal.reject(err)
                    return
                }
                seal.fulfill(())
            }
        }
    }
    
    private func logout() -> Promise<Void> {
        return Promise { seal in
            Installation.current()?.unlinkUser()
            User.logOutInBackground { (error) in
                if let err = error {
                    seal.reject(err)
                    return
                }
                seal.fulfill(())
            }
        }
        
    }
    
    // Check if userEmail is already in the system under an user type (organizer or customer)
    private func findUserType(_ email: String) -> Promise<UserType> {
        return Promise { seal in
            let query = User.query()
            query?.whereKey(User.Properties.email, equalTo: email)
            query?.limit = 1000
            query?.findObjectsInBackground(block: { (objects, error) in
                
                if let err = error {
                    seal.reject(RMBError.custom(error: err.localizedDescription))
                    return
                }
                
                if objects?.isEmpty ?? true {
                    seal.fulfill(UserType.customer)
                    return
                }
                
                guard let user = objects?.first as? User else {
                    seal.fulfill(UserType.customer)
                    return
                }
                
                switch UserType(rawValue: user.userType ?? "") {
                case .some(let userType):
                    seal.fulfill(userType)
                case .none:
                    seal.fulfill(UserType.customer)
                }
            })
        }
    }
    
    private func save() -> Promise<Void> {
        return Promise { seal in
            User.current()?.saveInBackground(block: { (_, error) in
                if let err = error {
                    seal.reject(err)
                } else {
                    seal.fulfill(())
                }
            })
        }
    }
}

extension AuthManager {
    
    /// @see https://docs.parseplatform.org/ios/guide/#error-codes
    class func logoutIfInvalidSession(error: Error?) {
        guard let err = error as NSError? else { return }
        
        print(#function)
        print(err.code)
        
        switch err.code {
        case 206, 209, 251, 253:
            AuthManager.logout()
            GRNNotif.invalidSession.postNotif(nil)
        default: break
        }
    }
}
