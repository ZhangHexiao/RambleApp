//
//  RMBCardView.swift
//  ramble-ios
//
//  Created by HexiaoZhang Ramble Technologies Inc. on 2020-08-08.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class RMBCardView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.AppColors.cardBackground.withAlphaComponent(0.5)
    }
}
