//
//  ButtonTheme.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-08-08.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

enum ButtonTheme: Int {
    case primary = 0
    case connectionCreate = 1
    case connectionLogin = 2
    case facebook = 3
    case red = 4
    case disabled = 5
    case green = 6
    
    var backgroundColor: UIColor {
        switch self {
        case .primary: return UIColor.AppColors.bgPrimaryButton
        case .connectionCreate: return UIColor.AppColors.bgConnectionCreateButton
        case .connectionLogin: return UIColor.AppColors.bgConnectionLoginButton
        case .red: return UIColor.AppColors.bgRedButton
        case .disabled: return UIColor.AppColors.bgDisabledButton
        case .facebook: return UIColor.AppColors.facebookBlue
        case .green: return UIColor.AppColors.green
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .primary, .connectionLogin, .red, .facebook, .green: return .white
        case .connectionCreate: return UIColor.AppColors.gray
        case .disabled: return UIColor.white.withAlphaComponent(0.4)
        }
    }
    
    var borderColor: UIColor? {
        switch self {
        case .primary: return UIColor.AppColors.borderPrimaryButton
        case .connectionCreate, .connectionLogin, .red, .disabled, .facebook, .green: return nil
        }
    }
    
    var font: UIFont {
        switch self {
        case .primary, .red, .disabled, .facebook, .green: return Fonts.Helvetica.bold.size(18)
        case .connectionCreate, .connectionLogin: return Fonts.Helvetica.bold.size(14)
        }
    }
}
