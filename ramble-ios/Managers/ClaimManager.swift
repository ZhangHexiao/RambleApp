//
//  ClaimManager.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-08.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class ClaimManager {
    typealias ClaimHandler = ((_ claim: Claim?, _ error: String?) -> Void)?
    
    /**
      Save it in the database
     */
    func save(claim: Claim, _ completion: ClaimHandler = nil) {
        claim.isEnabled = true
        
        claim.saveInBackground { (_, error) in
            completion?(claim, error?.localizedDescription)
        }
    }
    
}
