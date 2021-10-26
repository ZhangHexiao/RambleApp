//
//  CreditCardCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class CreditCardCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var creditCardIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with title: String?, subTitle: String?, cardViewModel: CardViewModel?) {
        titleLabel.text = title
        subtitleLabel.text = subTitle
        if let card = cardViewModel?.card {
            switch card.brand {
            case .visa:
                creditCardIcon.image = #imageLiteral(resourceName: "VisaCard")
            case .amex:
                creditCardIcon.image = #imageLiteral(resourceName: "amCreditCard")
            case .masterCard:
                creditCardIcon.image = #imageLiteral(resourceName: "masterCard")
            default:
                creditCardIcon.image = #imageLiteral(resourceName: "creditCard")
            }
        }
    }
}

extension CreditCardCell {
    static var kHeight: CGFloat { return 90 }
}
