//
//  SimpleTextSection.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-20.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class SimpleTextSection: UIView {
    @IBOutlet weak var contentLabel: UILabel!
    
    func configure(with title: String, appearanceType: SectionAppearance) {
        contentLabel.text = title
        contentLabel.font = appearanceType.font()
        backgroundColor = UIColor.AppColors.background
        contentLabel.textColor = appearanceType.textColor()
    }
}

extension SimpleTextSection {
    class func fromNib() -> SimpleTextSection {
        let nib = UINib(nibName: "SimpleTextSection", bundle: Bundle.main)
        // swiftlint:disable:next force_cast
        return nib.instantiate(withOwner: self, options: nil)[0] as! SimpleTextSection
    }
}

extension SimpleTextSection {
    static var kHeight: CGFloat { return 30 }

}
