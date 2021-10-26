//
//  FacebookManager.swift
//  ramble-ios
//
//  Created by Omran on 2018-10-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import PromiseKit
import Parse

typealias ListFriendsHandler = ((_ friends: [User], _ error: String?) -> Void)?

class FacebookManager {

    static let shared: FacebookManager = FacebookManager()
    
    var friends: [User] = []
    
    var hasEnabledFacebook: Bool {
        return User.current()?.facebookId != nil
    }
    
    private let permissions = ["email", "public_profile", "user_friends"]

    private init() { }
    
//    func fetchFriendsList(_ completion: ListFriendsHandler = nil) {
//        firstly {
//            importFacebookFriendsIds()
//        }.then { facebookIds in
//            self.getFriends(facebookIds: facebookIds)
//        }.done { friends in
//            self.friends = friends
//            completion?(friends, nil)
//        }.catch { error in
//            completion?([], error.localizedDescription)
//        }
//    }
    
//    private func importFacebookFriendsIds() -> Promise<[String]> {
//        return Promise { seal in
//            if !hasEnabledFacebook {
//                seal.reject(RMBError.invalidFacebookId)
//                return
//            }
//            var totalIds: [String] = []
////   ======Variable nextPage was never used, to get rid of warning==========
////          var nextPage = ""
//            GraphRequest(graphPath: "/me/friends?limit=1000").start { _, result, error in
//                if let err = error {
//                    seal.reject(err)
//                    return
//                }
//
//                guard let response = result as? [String: Any],
//                    let friendsList = response["data"] as? [[String: Any]],
//// =========== Change to get rid of warning=======================
//                    let _ = response["summary"] as? [String: Any],
//                    let _ = response["paging"] as? [String: Any] else {
//                        seal.reject(RMBError.gettingFriends)
//                        return
//                    }
////                    let summary = response["summary"] as? [String: Any],
////                    let paging = response["paging"] as? [String: Any] else {
////                    seal.reject(RMBError.gettingFriends)
////                    return
////                }
//                totalIds.append(contentsOf: friendsList.compactMap { $0["id"] as? String })
//                seal.fulfill(totalIds)
//            }
//        }
//    }
    
//    private func getFriends(facebookIds: [String]) -> Promise<[User]> {
//        return Promise { seal in
//            PFCloud.callFunction(inBackground: "defineFriendship", withParameters: ["facebookIds": facebookIds]) { result, error in
//                print("defineFriendship: \(error?.localizedDescription ?? "SUCCESS")")
//                if let err = error {
//                    seal.reject(err)
//                    return
//                }
//                guard let users = result as? [User] else {
//                    seal.reject(RMBError.gettingFriends)
//                    return
//                }
//                seal.fulfill(users)
//            }
//        }
//    }
}

extension FacebookManager {
    func linkUser(_ completion: @escaping (_ error: String?) -> Void) {
        firstly {
            self.linkFacebook()
        }.done {
            completion(nil)
        }.catch { (error) in
            print(error.localizedDescription)
            completion(error.localizedDescription)
            return
        }
    }
    
    func connectFacebook() -> Promise<Void> {
        return Promise { seal in
            PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { user, error in
                if let err = error {
                    seal.reject(err)
                    return
                }
                
                GraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name"]).start { _, graphResult, graphError in
                    if let err = graphError {
                        seal.reject(err)
                        return
                    }
                    
                    guard let currentUser = user as? User, let data = graphResult as? [String: AnyObject] else {
                        seal.reject(RMBError.linkFacebook)
                        return
                    }
                    
                    Installation.current()?.linkUser()
                    currentUser.isEnabled = true
                    currentUser.name = data["first_name"] as? String ?? ""
                    currentUser.lastName = data["last_name"] as? String ?? ""
                    currentUser.email = data["email"] as? String
                    currentUser.userType = UserType.customer.rawValue
                    currentUser.authType = UserAuthType.facebook.rawValue
                    currentUser.facebookId = data["id"] as? String
                    
                    currentUser.saveInBackground(block: { (_, error) in
                        if let err = error {
                            seal.reject(err)
                            return
                        }
                        seal.fulfill(())
                    })
                }
            }
        }
    }
    
    func linkFacebook() -> Promise<Void> {
        return Promise { seal in
            guard let currentUser = User.current() else { return }
            
            PFFacebookUtils.linkUser(inBackground: currentUser, withReadPermissions: permissions) { _, error in
                guard error == nil else {
                    seal.reject(RMBError.linkFacebook)
                    return
                }
                
                GraphRequest(graphPath: "me", parameters: ["fields": "email"]).start { _, graphResult, graphError in
                    
                    if let graphError = graphError {
                        seal.reject(graphError)
                        return
                    }
                    
                    guard let data = graphResult as? [String: AnyObject] else {
                        seal.reject(RMBError.linkFacebook)
                        return
                    }
                    
                    let facebookId = data["id"] as? String
                    currentUser.facebookId = facebookId
                    
                    UserManager().save(completion: { (error) in
                        if let err = error {
                            seal.reject(RMBError.custom(error: err))
                        } else {
                            seal.fulfill(())
                        }
                    })
                }
            }
        }
    }
}
