//
//  CityCell.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2019-12-28.
//  Copyright © 2019 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var cityLocation: UILabel!
    
    func configure(with type: CityType) {
//        categoryImageView.image = type.icon()
        cityName.text = type.localized()
        cityLocation.text = type.location()
//        categoryLabel.textColor = textColor
    }

    
}
extension CityCell {
    static var kHeight: CGFloat { return 80 }
}

