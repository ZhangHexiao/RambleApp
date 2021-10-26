//
//  RmbButton.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-19.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class RMBButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 16
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
    }
    
    // MARK: - IBInspectable
    
    @IBInspectable
    var theme: Int = 0 {
        didSet {
            switch theme {
            case ButtonTheme.primary.rawValue: // 0
                backgroundColor = ButtonTheme.primary.backgroundColor
                setTitleColor(ButtonTheme.primary.textColor, for: .normal)
                borderColor = ButtonTheme.primary.borderColor
                titleLabel?.font = ButtonTheme.primary.font
                isEnabled = true
            
            case ButtonTheme.connectionCreate.rawValue: // 1
                backgroundColor = ButtonTheme.connectionCreate.backgroundColor
                setTitleColor(ButtonTheme.connectionCreate.textColor, for: .normal)
                borderColor = ButtonTheme.connectionCreate.borderColor
                titleLabel?.font = ButtonTheme.connectionCreate.font
                isEnabled = true

            case ButtonTheme.connectionLogin.rawValue: // 2
                backgroundColor = ButtonTheme.connectionLogin.backgroundColor
                setTitleColor(ButtonTheme.connectionLogin.textColor, for: .normal)
                borderColor = ButtonTheme.connectionLogin.borderColor
                titleLabel?.font = ButtonTheme.connectionLogin.font
                isEnabled = true

            case ButtonTheme.facebook.rawValue: // 3
                backgroundColor = ButtonTheme.facebook.backgroundColor
                setTitleColor(ButtonTheme.facebook.textColor, for: .normal)
                borderColor = ButtonTheme.facebook.borderColor
                titleLabel?.font = ButtonTheme.facebook.font
                isEnabled = true

            case ButtonTheme.red.rawValue: // 4
                backgroundColor = ButtonTheme.red.backgroundColor
                setTitleColor(ButtonTheme.red.textColor, for: .normal)
                borderColor = ButtonTheme.red.borderColor
                titleLabel?.font = ButtonTheme.red.font
                isEnabled = true

            case ButtonTheme.disabled.rawValue: // 5
                backgroundColor = ButtonTheme.disabled.backgroundColor
                setTitleColor(ButtonTheme.disabled.textColor, for: .normal)
                borderColor = ButtonTheme.disabled.borderColor
                titleLabel?.font = ButtonTheme.disabled.font
                isEnabled = true
                
            case ButtonTheme.green.rawValue: // 6
                backgroundColor = ButtonTheme.green.backgroundColor
                setTitleColor(ButtonTheme.green.textColor, for: .normal)
                borderColor = ButtonTheme.green.borderColor
                titleLabel?.font = ButtonTheme.green.font
                isEnabled = true

            default: break
            }
        }
    }
}
