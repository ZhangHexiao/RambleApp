//
//  ProfileCoverCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-25.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class ProfileCoverCell: UITableViewCell {
   
    @IBOutlet weak var centerToolTipView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profileRingPicture: RMBRingProfilePicture!
    @IBOutlet weak var eventsLabel: UILabel!
    
    func configure(with viewModel: ProfileViewModel) {
        fullNameLabel.text = viewModel.fullName
        eventsLabel.text = viewModel.nbEvents
        
        ImageHelper.loadImage(data: viewModel.user?.profileImage) { [weak self] (profileImage) in
            self?.profileRingPicture.configure(with: profileImage ?? #imageLiteral(resourceName: "ic_user_placeholder"), andType: viewModel.ring())
        }
        
        ImageHelper.loadImage(data: viewModel.user?.coverImage) { [weak self] (cover) in
            self?.coverImageView.image = cover
            self?.coverImageView.layer.cornerRadius = 16
        }
        
        if UserDefaults.shouldShowToolTip(for: .profile) {
            showToolTip()
        }
    }
    
    private func showToolTip() {
        var preferences = EasyTipView.globalPreferences
        preferences.drawing.arrowPosition = .left
        
        EasyTipView.show(forView: centerToolTipView,
                         withinSuperview: self,
                         text: "Tap on your profile picture to see how to get to the next band".localized,
                         preferences: preferences,
                         delegate: nil)
    }
}

extension ProfileCoverCell {
    static var kHeight: CGFloat { return 237 }
}
