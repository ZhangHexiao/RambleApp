//
//  UILabel.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-17.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

public extension UILabel {
    @IBInspectable var localizedText: String? {
        get {
            return self.text
        }
        set {
            guard let key = newValue else {
                return
            }
            self.text = NSLocalizedString(key, comment: "")
        }
    }
    
    func addCharacterSpacing(kernValue: Double = 2.15) {
      if let labelText = text, labelText.count > 0 {
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
        attributedText = attributedString
      }
    }
    
}
