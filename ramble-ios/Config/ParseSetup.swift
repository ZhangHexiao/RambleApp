//
//  ParseSetup.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-06.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class ParseSetup {
    
    static func setup() {
        self.registerSubclasses()
        self.setupConnection()
        self.setupInstallInformation()
    }
    
    /// Create parse connection
    static func setupConnection() {
        let configuration = ParseClientConfiguration {
            $0.applicationId = Config.Parse.credentials.appId
            $0.server = Config.Parse.credentials.url
            $0.isLocalDatastoreEnabled = true
        }
        Parse.initialize(with: configuration)
    }
    
    /// Perform Parse subclass registration
    static func registerSubclasses() {
        //Chat.registerSubclass()
        // Message.registerSubclass()
    }
    
    static func setupInstallInformation() {
        Installation.current()?.setupGlobalInformations()
    }
}

func == (lhs: User, rhs: User) -> Bool {
    return lhs.objectId == rhs.objectId
}

func == (lhs: PFObject, rhs: PFObject) -> Bool {
    return lhs.objectId == rhs.objectId
}
