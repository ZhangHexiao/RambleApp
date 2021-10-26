//
//  SectionDurationCell.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-07-04.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class SectionDurationCell: UICollectionViewCell {
    

    @IBOutlet weak var durationBackgroundView: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            self.durationBackgroundView.backgroundColor = isSelected ? UIColor.white : UIColor.AppColors.backgroundReceiver
            self.durationLabel.textColor = isSelected ? UIColor.black : UIColor.white
        }
      }
    
    func configure(with ticketViewModel: TicketViewModel) {
        let start = RMBDateFormat.hourMin.formatted(date: ticketViewModel.startAt)
        let end = RMBDateFormat.hourMin.formatted(date: ticketViewModel.endAt)
        durationBackgroundView.roundCorner(with: 18)
        durationLabel.text = "\(start)-\(end)"
    }

}
extension SectionDurationCell {
    static var kHeight: CGFloat { return 100 }
}
