//
//  NewEventCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-02.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class NewEventCell: UITableViewCell {
    
    @IBOutlet weak var contentTitleLabel: UILabel!
    
    func configure(with title: String) {
        contentTitleLabel.text = title
    }
}

extension NewEventCell {
    static var kHeight: CGFloat { return 61 }
}
