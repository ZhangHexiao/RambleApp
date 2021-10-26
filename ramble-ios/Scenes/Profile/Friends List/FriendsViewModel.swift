//
//  ListFriendsViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-31.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

class FriendsViewModel {

    var friends: [User] = []
    
    var buttonTitle: String {
        return String(format: "see".localized, String(friends.count))
    }
    
    init(users: [User]? = nil) {
        if let users = users {
            friends = users.sorted(by: { (lhs, hrs) -> Bool in
                lhs.name ?? "a" < hrs.name ?? "b"
            })
        } else {
            friends = []
        }
    }
}

extension FriendsViewModel {
    var numberOfRows: Int { return friends.count }
    
    var visiblePictures: Int {
        if friends.count > 4 { return 4 }
        return numberOfRows
    }
    
    func url(for item: Int) -> URL? {
        if let urlString = friends[item].profileImage?.url {
            return URL(string: urlString)
        }
        return nil
    }
    
    func user(for item: Int) -> User {
        return friends[item]
    }
    
    func friendCellViewModel(for item: Int) -> FriendCellViewModel {
        return FriendCellViewModel(user: friends[item])
    }
    
    func profileViewModel(for item: Int) -> ProfileViewModel {
        return ProfileViewModel(user: friends[item], type: .friend)
    }
}
