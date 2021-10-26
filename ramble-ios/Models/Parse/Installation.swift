//
//  Installation.swift
//  ramble-ios
//
//  Created by Hexiao Zhang. on 2020-06-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class Installation: PFInstallation {
    /*!
     *  SHUser userId. Mandatory for push notifications
     */
    @NSManaged var user: User?
    
    /*!
     *  The current version of the app
     */
    @NSManaged var appRealVersion: String?
    
    /*!
     *  The iOS current Version
     */
    @NSManaged var osVersion: String?
    
    /*!
     *  The type of device
     */
    @NSManaged var deviceTypeDetailed: String?
    
    // MARK: LANG
    
    /*!
     *  Lang of installation
     */
    @NSManaged var lang: String?
    
    /*!
     *  Region. Ex US for United States of America
     */
    @NSManaged var region: String?
    
    // MARK: Functions
    
    /*! Used for loggin global informations about device on Parse */
    func setupGlobalInformations() {
        self.setupBasicInformations()
        self.setupLanguageInformations()
        self.saveInBackground()
    }
    
    /*! Link current installation with current user */
    func linkUser() {
        if let currentUser = User.current() {
            self.user = currentUser
            self.saveInBackground()
        }
    }
    
    /*! Unlink current installation from users */
    func unlinkUser() {
        self.user = nil
        self.saveInBackground()
    }
    
    /*!
     *  Basics of installation informations
     */
    private func setupBasicInformations() {
//        let infoDic = mainBundle.infoDictionary!
//        let currentVersion: String = infoDic["CFBundleShortVersionString"] as? String ?? ""
//        self.appRealVersion = currentVersion
//        let currSysVer = device.systemVersion
//        self.osVersion = currSysVer
//        let deviceName = device.deviceName
//        self.deviceTypeDetailed = deviceName
    }
    
    /*!
     *  Setup datas according to language
     */
    private func setupLanguageInformations() {
        self.region = Locale.current.regionCode
        self.lang = Locale.current.languageCode
        
        if let lang = self.lang, let region = self.region {
            print("Lang : \(lang)")
            print("Lang Region : \(region)")
        } else {
            print("Lang or region not found for : \(Locale.current.description)")
        }
    }
    
    /// Reset the badge that shows on app icon
    /// set the Installation badge to 0
    func resetBadge() {
        guard let installation = Installation.current() else { return }
        
        if installation.badge > 0 {
            installation.badge = 0
            installation.saveInBackground()
        }
    }
}

extension Installation {
    struct Properties {
        static let user = "user"
    }
}
