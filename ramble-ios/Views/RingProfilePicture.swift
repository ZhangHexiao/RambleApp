//
//  RingProfilePicture.swift
//  ramble-ios
//
//  Created by Raphael on 2018-08-22.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class RMBRingProfilePicture: UIView {
//    ======Here we set the ringWidth:CGFloat to 0 to get rid of ring==
    func configure(with image: UIImage, ringWidth: CGFloat = 0, andType type: BandType) {
        subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView(frame: bounds.insetBy(dx: ringWidth-1, dy: ringWidth-1))
        
        imageView.image = image
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
        imageView.masksToBounds = true
        imageView.borderWidth = 0
        
        let band = type.bandRing(for: bounds, and: ringWidth)
        
        addSubview(band)
        addSubview(imageView)

    }
}
