//
//  UIButton.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-17.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

public extension UIButton {
    @IBInspectable var localizedText: String? {
        get {
            return self.title(for: .normal)
        }
        set {
            guard let key = newValue else {
                return
            }
            self.setTitle(NSLocalizedString(key, comment: ""), for: .normal)
        }
    }
    
    @IBInspectable var numberOfLines: Int {
        get {
            return self.titleLabel?.numberOfLines ?? 1
        }
        set {
//  ========HX:this line of code may not be correct, changed as below=========
//           self.titleLabel?.numberOfLines = numberOfLines
             self.titleLabel?.numberOfLines = newValue
        }
    }
    
    func flash() {
       let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3        
        layer.add(flash, forKey: nil)
    }
    
    func pulsate() {
       let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.90
        pulse.toValue = 1.02
        pulse.autoreverses = true
        pulse.repeatCount = 600
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    
    
    
    
}
