//
//  SeeTicketsCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class SeeTicketsCell: UITableViewCell {

    @IBOutlet weak var seeTicketsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        seeTicketsLabel.text = "See my tickets".localized
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
