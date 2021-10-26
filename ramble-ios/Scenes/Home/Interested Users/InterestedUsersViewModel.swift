//
//  InterestedUsersViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

enum InterestedUsersControllerType {
    case users, friends
}

protocol InterestedUsersViewModelDelegate: class {
    
}

class InterestedUsersViewModel {
    
    var eventViewModel: EventViewModel
    var friendsViewModel: FriendsViewModel
    
    weak var delegate: InterestedUsersViewModelDelegate?
    
    var controllerType: InterestedUsersControllerType = .users
    
    var title: String {
        switch controllerType {
        case .friends:
            return "Interested Friends".localized
        case .users:
            return "Interested Users".localized
        }
    }
    
    init(eventViewModel: EventViewModel, friendsViewModel: FriendsViewModel) {
        self.eventViewModel = eventViewModel
        self.friendsViewModel = friendsViewModel
    }
}
