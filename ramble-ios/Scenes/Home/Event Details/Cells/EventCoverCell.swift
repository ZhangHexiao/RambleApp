//
//  EventCoverCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit
import Foundation

class EventCoverCell: UITableViewCell {
    
    @IBOutlet weak var rmbBackgroundView: RMBCardView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerImageView: RMBRoundImage!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    weak var delegate: DisplayFullScreenImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        coverImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCoverImage)))
        
        ownerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOwnerImage)))
    }
 
    // swiftlint:disable:next function_parameter_count
    func configure(eventName: String, eventImage: UIImage?, owner: String, ownerImage: UIImage?, isVerified: Bool, hasFriendsInterested: Bool) {
        eventTitleLabel.text = eventName
        coverImageView.image = eventImage
        ownerNameLabel.text = owner
        ownerImageView.image = ownerImage ?? #imageLiteral(resourceName: "ic_user_tab")
        
        badgeImageView.isHidden = !isVerified
        
        if hasFriendsInterested {
            rmbBackgroundView.layer.cornerRadius = 0
            rmbBackgroundView.roundCorner(with: 16, to: [.topLeft, .topRight])
        } else {
            rmbBackgroundView.layer.cornerRadius = 16
        }
    }
    
    @objc private func didTapCoverImage() {
        guard let image = coverImageView.image else { return }
        delegate?.didTapImage(image, imageView: coverImageView)
    }
    
    @objc private func didTapOwnerImage() {
        guard let image = ownerImageView.image else { return }
        delegate?.didTapImage(image, imageView: ownerImageView)
    }
}
