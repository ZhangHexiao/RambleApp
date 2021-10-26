//
//  NotificationCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-19.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var notificationImage: RMBRoundImage!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var separator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        separator.alpha = 0.5

    }
    
    func configure(viewModel: NotificationCellViewModel, position: LayoutFriendCellPosition = .any) {
        
        hasMarkedAsRead(viewModel.hasSeen)
        
        contentLabel.text = viewModel.message
        dateLabel.text = viewModel.dateFormatted
        
        viewModel.loadCoverImage { [weak self] (image) in
            self?.notificationImage.image = image
        }
        
        configLayout(for: position)

    }
    
    private func hasMarkedAsRead(_ hasRead: Bool) {
        if hasRead {
            contentLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        } else {
            contentLabel.textColor = UIColor.white
        }
    }
    
    private func configLayout(for position: LayoutFriendCellPosition = .any) {
        
        background.roundCorner(with: 0, to: .allCorners)
        separator.isHidden = false

        switch position {
        case .firstAndLast:
            background.roundCorner(with: 16, to: .allCorners)
            separator.isHidden = true
        case .first:
            background.roundCorner(with: 16, to: [.topLeft, .topRight])
        case .last:
            background.roundCorner(with: 16, to: [.bottomLeft, .bottomRight])
            separator.isHidden = true
        case .any: break
        }
    }
}
