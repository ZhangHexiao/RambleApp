//
//  CategoryCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-19.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!

    @IBOutlet weak var cardView: RMBCardView!
    
    func configure(with type: CategoryType, textColor: UIColor = UIColor.white.withAlphaComponent(0.5)) {
        categoryImageView.image = type.icon()
        categoryLabel.text = type.localized()
        categoryLabel.textColor = textColor
    }
    
    func configure(with type: CategoryType, isSelected: Bool = false) {
        categoryImageView.image = type.icon()
        categoryLabel.text = type.localized()
        
        if isSelected {
            categoryLabel.textColor = UIColor.white
            cardView.backgroundColor = UIColor.AppColors.gray.withAlphaComponent(0.5)
        } else {
            categoryLabel.textColor = UIColor.white.withAlphaComponent(0.5)
            cardView.backgroundColor = UIColor.AppColors.cardBackground.withAlphaComponent(0.5)
        }
    }
    
}

extension CategoryCell {
    static var kHeight: CGFloat { return 72 }
}
