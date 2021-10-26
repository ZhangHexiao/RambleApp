//
//  ReportUserManager.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-09.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Parse

class ReportUserManager {
    
    /**
     Report an user into parse if user hasn't reported yet
     - parameter user: Object User.
     - parameter completion: Return error if any
     - returns: void.
     */
    func createReport(user: User?, type: ReportUserType, _ completion: SuccessHandler = nil) {
        
        firstly {
            hasUserBeenReported(user: user)
        }.then { _ in
            self.save(user: user, type: type)
        }.done { success in
            completion?(success, nil)
        }.catch { error in
            completion?(false, error.localizedDescription)
        }
    }
    
    /**
     Check if an user has been reported by the current user
     ```
     ```
     - parameter user: Object User.
     - returns: Promise<Bool>.
     */
    func hasUserBeenReported(user: User?) -> Promise<Bool> {
        return Promise { seal in
            guard let current = User.current(), let user = user else { seal.reject(RMBError.unknown); return }
            
            let query = ReportedUser.query()
            query?.limit = 1000
            query?.whereKey(ReportedUser.Properties.isEnabled, equalTo: true)
            query?.whereKey(ReportedUser.Properties.userReported, equalTo: user)
            query?.whereKey(ReportedUser.Properties.user, equalTo: current)
            query?.getFirstObjectInBackground(block: { (object, _) in
                if object != nil {
                    seal.reject(RMBError.reportedTooManyTimes)
                } else {
                   seal.fulfill(false)
                }
            })
        }
    }
    
    /**
     Create report on the database
     ```
     ```
     - parameter user: Object User.
     - returns: Promise<ReportedUser?>.
     */
    func save(user: User?, type: ReportUserType) -> Promise<Bool> {
        return Promise { seal in
            guard let current = User.current(), let user = user else { seal.reject(RMBError.unknown); return }
            
            let reportedUser = ReportedUser()
            reportedUser.isEnabled = true
            reportedUser.user = current
            reportedUser.userReported = user
            reportedUser.reportType = type.rawValue
            reportedUser.saveInBackground(block: { (success, error) in
                if let err = error {
                    seal.reject(err)
                } else {
                    seal.fulfill(success)
                }
            })
        }
    }
}
