//
//  MessageManager.swift
//  ChatExample
//
//  Created by Hexiao Zhang on 2020-04-13.
//  Copyright © 2020 MessageKit. All rights reserved.
//
import Foundation
import UIKit

extension UIColor {
    static let primaryColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
}

@IBDesignable open class LocalizableLabel: UILabel {
    
    @IBInspectable open var localizeString:String = "" {
        didSet {
            #if TARGET_INTERFACE_BUILDER
            let bundle = Bundle(for: type(of: self))
            self.text = bundle.localizedString(forKey: self.localizeString, value:"", table: nil)
            #else
            self.text = self.localizeString
            #endif
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.preferredMaxLayoutWidth = self.frame.size.width
        self.layoutIfNeeded()
    }
}

@IBDesignable open class LocalizableButton: UIButton {
    
    @IBInspectable open var localizeString:String = "" {
        didSet {
            #if TARGET_INTERFACE_BUILDER
            let bundle = Bundle(for: type(of: self))
            self.setTitle(bundle.localizedString(forKey: self.localizeString, value:"", table: nil), for: .normal)
            #else
            self.setTitle(self.localizeString, for: .normal)
            #endif
        }
    }
}
