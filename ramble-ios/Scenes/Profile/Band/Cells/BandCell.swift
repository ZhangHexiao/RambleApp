//
//  BandCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class BandCell: UITableViewCell {

    @IBOutlet weak var bandRing: RMBRingProfilePicture!
    @IBOutlet weak var bandName: UILabel!
    @IBOutlet weak var eventsRequired: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with image: UIImage, band: BandType, currentNbEvents: Int) {
        bandRing.configure(with: image, andType: band)
        
        bandName.text = band.name()
        let strEventsRequired = "events required".localized
        eventsRequired.text = "\(band.eventRequired()) " + strEventsRequired
        
        if band.eventRequired() <= currentNbEvents {
            bandName.textColor = .white
            eventsRequired.textColor = .white
            bandRing.alpha = 1
        } else {
            bandName.textColor = UIColor.white.withAlphaComponent(0.5)
            eventsRequired.textColor = UIColor.white.withAlphaComponent(0.5)
             bandRing.alpha = 0.3
        }
    }
}

extension BandCell {
    static var kHeight: CGFloat { return 120.0 }
}
