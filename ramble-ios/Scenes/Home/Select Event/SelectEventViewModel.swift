//
//  SelectEventViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-31.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

typealias SelectEventDelegate = Failable & Loadable

class SelectEventViewModel {
    
    weak var delegate: SelectEventDelegate?
    
    var events: [EventViewModel] = []
    
    var friend: User?
    
    func loadData() {
        EventManager().getAllRelatedEvents { [weak self] (events, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: true)
            } else {
                self?.events = events.map { EventViewModel(event: $0)}
                self?.delegate?.didLoadData()
            }
        }
    }
    
    func sendInvitation() {
        guard let sender = User.current(), let receiver = friend else {
            delegate?.didFail(error: RMBError.emptySelectFriend.localizedDescription, removeFromTop: true)
            return
        }
        
        for viewModel in events where viewModel.isSelected {
            PushNotificationManager().sendPushNotification(sender: sender, receiver: receiver, event: viewModel.event, type: .invitation)
        }
    }
}

extension SelectEventViewModel {
    var isEmpty: Bool { return events.isEmpty }
    
    var numberOfRows: Int { return events.count }
    
    func event(for indexPath: IndexPath) -> EventViewModel {
        return events[indexPath.row]
    }
    
    func select(at indexPath: IndexPath) {
        events[indexPath.row].isSelected.toggle()
    }
}
