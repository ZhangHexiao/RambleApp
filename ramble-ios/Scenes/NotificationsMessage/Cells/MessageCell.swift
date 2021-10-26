//
//  MessageCell.swift
//  ChatExample
//
//  Created by Hexiao Zhang on 2020-04-13.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import UIKit

//-------------------------------------------------------------------------------------------------------------------------------------------------
class MessageCell: UITableViewCell {

    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var labelInitials: UILabel!
    @IBOutlet var labelDetails: UILabel!
    @IBOutlet var labelLastMessage: UILabel!
    @IBOutlet var labelElapsed: UILabel!
    @IBOutlet var imageMuted: UIImageView!
    @IBOutlet var viewUnread: UIView!
    @IBOutlet var labelUnread: UILabel!
    @IBOutlet weak var UnreadCircle: UIImageView!
//-------------------------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func configure(viewModel: MessageCellViewModel) {

        var displayUser  = viewModel.message.firstUser
        var unreadNumber = viewModel.message.unreadSecond
        
        if viewModel.message.firstUser == User.current()
        {
            displayUser  = viewModel.message.secondUser
            unreadNumber = viewModel.message.unreadFirst
        }
        
        labelDetails.text = (displayUser?.name ?? displayUser?.organizationName) ??  "Undfeind"
        
        labelLastMessage.text = viewModel.message.lastPost?.content

        labelElapsed.text = TimeConvert.timeCustomMessage((viewModel.message.lastPost?.createdAt)!)
//            viewModel.message.lastPost?.createdAt?.timeAgoSinceDate(numericDates: true) ?? "Just now"
        imageMuted.isHidden = !(viewModel.message.isMuteUser)
//        imageMuted.isHidden = (chat.mutedUntil < Date().timestamp())
        labelUnread.isHidden = true
        viewUnread.isHidden = (unreadNumber == 0)
        labelUnread.text = (unreadNumber < 100) ? "\(unreadNumber )" : "..."
        UnreadCircle.isHidden  = (unreadNumber == 0)
        ImageHelper.loadImage(data: displayUser?.profileImage) { [weak self] (image) in
            if image == nil {
            self?.imageUser.image = #imageLiteral(resourceName: "ic_user_placeholder")
            } else {
                self?.imageUser.image = image}
        }
    }
}

extension MessageCell {
    static var kHeight: CGFloat { return 70.0 }

}
