//
//  FriendCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-30.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

enum LayoutFriendCellPosition { case first, last, any, firstAndLast }

class FriendCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: RMBRoundImage!
    var viewModel: FriendCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        background.clipsToBounds = true
        background.backgroundColor = UIColor.AppColors.background
        separator.alpha = 0.5
    }

    func configure(with viewModel: FriendCellViewModel, position: LayoutFriendCellPosition = .any) {
        self.viewModel = viewModel
        
        nameLabel.text = viewModel.fullName
        viewModel.loadProfileImage { [weak self] (image) in
            self?.profileImageView.image = image ?? #imageLiteral(resourceName: "ic_user_placeholder")
        }
        
        configLayout(for: position)
    }
    
    private func configLayout(for position: LayoutFriendCellPosition = .any) {
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

extension FriendCell {
    static var kHeight: CGFloat { return 64 }
}
