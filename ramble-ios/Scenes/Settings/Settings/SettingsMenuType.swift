//
//  SettingsMenuType.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

enum SettingsMenuType: Int, CaseIterable {
    case editProfile
    case changePassword
    case terms
    case privacy
    case contactUs
    case logout
    case none
    
    func icon() -> UIImage {
        switch self {
        case .editProfile: return #imageLiteral(resourceName: "ic_pen")
        case .changePassword: return #imageLiteral(resourceName: "ic_key")
        case .terms: return #imageLiteral(resourceName: "ic_paper")
        case .privacy: return #imageLiteral(resourceName: "ic_hand")
        case .contactUs: return #imageLiteral(resourceName: "ic_email")
        case .logout: return #imageLiteral(resourceName: "ic_logout")
        case .none: return UIImage()
        }
    }
    
    func hasIndicator() -> Bool {
        switch self {
        case .editProfile, .changePassword, .terms, .privacy, .contactUs: return true
        case .logout, .none: return false
            
        }
    }
    
    func localized() -> String {
        switch self {
        case .editProfile: return "Edit Profile".localized
        case .changePassword: return "Change password".localized
        case .terms: return "Terms and conditions".localized
        case .privacy: return "Privacy Policy".localized
        case .contactUs: return "Contact us".localized
        case .logout: return "Log out".localized
        case .none: return ""
        }
    }
    
    static var kNumberOfItems: Int { return 6 }
}
