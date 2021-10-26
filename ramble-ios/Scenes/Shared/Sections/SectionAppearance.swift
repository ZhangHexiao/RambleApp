//
//  SectionAppearance.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-30.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

enum SectionAppearance {
    case category, date
    
    func font() -> UIFont {
        switch self {
        case .category:
            return Fonts.Futura.medium.size(14)
        case .date:
            return Fonts.Futura.medium.size(16)
        }
    }
    
    func textColor() -> UIColor {
        switch self {
        case .category:
            return UIColor.white.withAlphaComponent(0.5)
        case .date:
            return UIColor.AppColors.gray
        }
    }
    
}
