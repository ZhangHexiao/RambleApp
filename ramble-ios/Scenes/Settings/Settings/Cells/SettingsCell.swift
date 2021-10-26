//
//  SettingsCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var indicatorView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with type: SettingsMenuType) {
        iconImageView.image = type.icon()
        contentLabel.text = type.localized()
        indicatorView.isHidden = !type.hasIndicator()
    }
}

extension SettingsCell {
    static var kHeight: CGFloat { return 72.0 }

}
