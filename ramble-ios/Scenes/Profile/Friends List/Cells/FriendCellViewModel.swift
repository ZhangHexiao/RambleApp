//
//  FriendCellViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-31.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

class FriendCellViewModel {
    
    var friend: User
    
    var fullName: String {
        return (friend.name ?? "") + " " + (friend.lastName ?? "")
    }
    init(user: User) {
        friend = user
    }
}

extension FriendCellViewModel {
    
    func loadProfileImage(_ done: @escaping (_ img: UIImage?) -> Void) {
        ImageHelper.loadImage(data: friend.profileImage) { [weak self] (image) in
            self?.friend.cachedProfileImage = image
            done(image)
        }
    }
}
