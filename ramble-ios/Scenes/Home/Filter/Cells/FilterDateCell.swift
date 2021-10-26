//
//  FilterDateCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-19.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class FilterDateCell: UITableViewCell {

    @IBOutlet weak var typeDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with placeHolder: String, title: String?) {
        if let title = title {
            typeDateLabel.text = title
            dateLabel.text = ""
        } else {
            typeDateLabel.text = placeHolder
            dateLabel.text = "Select a date".localized
        }
    }
}

extension FilterDateCell {
    static var kHeight: CGFloat { return 72 }
}
