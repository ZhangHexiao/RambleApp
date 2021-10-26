//
//  GuestNumberCell.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-07-08.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class GuestNumberCell: UITableViewCell {
    
    @IBOutlet weak var numberOfGuest: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with guests: Int = 0) {
        numberOfGuest.text = String(guests)
     }
    
}
extension GuestNumberCell {
    static var kHeight: CGFloat { return 90 }
}
