//
//  UserLocationCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-12.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class UserLocationCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    
    func configure(with text: String) {
        addressLabel.text = text
    }
}
