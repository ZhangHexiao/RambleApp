//
//  EventDetailsListFriendsCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-28.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol EventDetailsListFriendsCellDelegate: class {
    func didTapSeeAllFriends()
    func didTapSeeFriend(profileViewModel: ProfileViewModel)
}

class EventDetailsListFriendsCell: UITableViewCell {

    @IBOutlet weak var rmbBackgroundView: RMBCardView!
    @IBOutlet weak var participantsPictures: OnlyHorizontalPictures!

    weak var delegate: EventDetailsListFriendsCellDelegate?

    @IBOutlet weak var seeButton: UIButton!
    
    var viewModel: FriendsViewModel = FriendsViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        participantsPictures.dataSource = self
        participantsPictures.delegate = self
        participantsPictures.alignment = .left
        participantsPictures.spacingColor = UIColor.clear
        participantsPictures.fontForCount = Fonts.Futura.medium.size(12)
        participantsPictures.countPosition = .right
        participantsPictures.recentAt = .left
        participantsPictures.spacing = 3
    }

    func configure(with viewModel: FriendsViewModel, delegate: EventDetailsListFriendsCellDelegate?) {
        self.delegate = delegate
        self.viewModel = viewModel
    
        seeButton.setTitle(viewModel.buttonTitle, for: .normal)
        
        participantsPictures.reloadData()
        
        rmbBackgroundView.roundCorner(with: 16, to: [.bottomLeft, .bottomRight])
    }
    
    @IBAction func actionSeeAll() {
        delegate?.didTapSeeAllFriends()
    }
}

extension EventDetailsListFriendsCell: OnlyPicturesDataSource {
    
    func numberOfPictures(onlyPictureView: OnlyPictures) -> Int {
        return viewModel.friends.count
    }
    
    func visiblePictures(onlyPictureView: OnlyPictures) -> Int {
        return viewModel.numberOfRows
    }
    
    func pictureViews(onlyPictureView: OnlyPictures, _ imageView: UIImageView, index: Int) {
        imageView.image = #imageLiteral(resourceName: "ic_user_placeholder") 
        ImageHelper.loadImage(data: viewModel.user(for: index).profileImage) { (image) in
            imageView.image = image ?? #imageLiteral(resourceName: "ic_user_placeholder")
        }
    }
}

extension EventDetailsListFriendsCell: OnlyPicturesDelegate {
    func pictureView(onlyPictureView: OnlyPictures, _ imageView: UIImageView, didSelectAt index: Int) {
        delegate?.didTapSeeFriend(profileViewModel: viewModel.profileViewModel(for: index))
    }
}
