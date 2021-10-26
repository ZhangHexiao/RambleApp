//
//  MessageCellViewModel.swift
//  ChatExample
//
//  Created by Hexiao Zhang on 2020-04-14.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation
import UIKit

class MessageCellViewModel {
    
    var message: Message
    
    init(message: Message) {
        self.message = message
    }
    
    var hasSeen: Bool {
        return message.hasSeen ?? true
    }
    
    var dateFormatted: String {
        return message.createdAt?.timeAgoSinceDate(numericDates: true) ?? "Just now".localized
    }
    
    func loadCoverImage(_ done: @escaping (_ img: UIImage?) -> Void) {
        if message.firstUser!.cachedProfileImage != nil {
            done(message.firstUser!.cachedProfileImage)
                return
            }
            ImageHelper.loadImage(data: message.firstUser!.profileImage) { [weak self] (image) in
                self?.message.firstUser?.cachedProfileImage = image
                done(image)
            }
    }
}
