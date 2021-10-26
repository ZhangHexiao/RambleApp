//
//  TicketView.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class TicketView: UIView {
    
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var codeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 16
    }
    
    func configure(viewModel: TicketBoughtViewModel?) {
        guard let viewModel = viewModel else { return }
        
        ticketLabel.text = viewModel.ticketNumberFormatted
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        codeImageView.generateQRCode(code: viewModel.code)
    }
}

extension TicketView {
    class func fromNib() -> TicketView {
        let nib = UINib(nibName: "TicketView", bundle: Bundle.main)
        // swiftlint:disable:next force_cast
        return nib.instantiate(withOwner: self, options: nil)[0] as! TicketView
    }
}
