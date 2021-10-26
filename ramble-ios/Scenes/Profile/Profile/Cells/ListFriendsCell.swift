//
//  ListFriendsCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-26.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol ListFriendsCellDelegate: class {
    func didTapSeeAllFriends()
    func didTapSeeFriend(profileViewModel: ProfileViewModel)
}

class ListFriendsCell: UITableViewCell {

    @IBOutlet weak var myFriendsLabel: UILabel!
    @IBOutlet weak var seeButton: UIButton!
    @IBOutlet weak var participantsPictures: OnlyHorizontalPictures!

    weak var delegate: ListFriendsCellDelegate?
    
    var viewModel: FriendsViewModel = FriendsViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        participantsPictures.dataSource = self
        participantsPictures.delegate = self
        participantsPictures.alignment = .left
        participantsPictures.spacingColor = UIColor.AppColors.background
        participantsPictures.fontForCount = Fonts.Futura.medium.size(12)
        participantsPictures.recentAt = .left
        participantsPictures.spacing = 3
        myFriendsLabel.text = "My Friends".localized
    }
    
    func configure(with viewModel: FriendsViewModel, delegate: ListFriendsCellDelegate?) {
        self.delegate = delegate
        self.viewModel = viewModel
        
        seeButton.setTitle(viewModel.buttonTitle, for: .normal)
        participantsPictures.reloadData()
    }
    
    @IBAction func actionSee() {
        delegate?.didTapSeeAllFriends()
    }
    
}

extension ListFriendsCell: OnlyPicturesDataSource {
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

extension ListFriendsCell: OnlyPicturesDelegate {
    func pictureView(onlyPictureView: OnlyPictures, _ imageView: UIImageView, didSelectAt index: Int) {
        delegate?.didTapSeeFriend(profileViewModel: viewModel.profileViewModel(for: index))
    }
}

extension ListFriendsCell {
    static var kHeight: CGFloat { return 80 }
}
