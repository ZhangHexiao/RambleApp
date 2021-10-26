//
//  LogoLabel.swift
//  ramble-ios
//
//  Created by Omran on 2019-06-06.
//  Copyright © 2019 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class LogoLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 12, right: 0)
        super.drawText(in: self.frame.inset(by: insets))
    }
}
