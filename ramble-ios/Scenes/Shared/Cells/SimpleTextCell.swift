//
//  SimpleTextCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-03.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class SimpleTextCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with title: String, color: UIColor) {
        titleLabel.text = title
        titleLabel.textColor = color
    }
    
    func configure(with placeHolder: String, content: String?) {
        titleLabel.text = content == nil ? placeHolder : content
        titleLabel.textColor = content == nil ? UIColor.AppColors.placeHolderGray : .white
    }
}

extension SimpleTextCell {
    static var kHeight: CGFloat { return 61 }
}
