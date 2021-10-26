//
//  ProfileViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-26.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import PromiseKit

enum ProfileSectionType {
    case cover, interested, created, myTickets, section
//====hide friend currently====
//    , friends, facebookConnect
}

enum ProfileType {
    case mine
    case friend
}

protocol ProfileViewModelDelegate: class {
    func didLoadData()
    func didSuccess(msg: String)
    func didFail(error: String)
}

class ProfileViewModel {
    
    weak var delegate: ProfileViewModelDelegate?
    
    /*
     User to populate the view
     */
    var user: User?
    
    /*
     Friends from facebook using the app
    //currently do not apply this feature
     */
    var friends: [User] = []
    
    var friendsViewModel: FriendsViewModel {
        return FriendsViewModel(users: friends)
    }
    
    /*
     Events created by this user
     */
    var lastEventCreated: Event?
    var eventsCreatedCount: Int32 = 0
    
    /*
     Events interested by this user
     */
    var lastEventInterested: Event?
    var eventsInterestedCount: Int32 = 0
    
    /*
     Events with tickets bought by this user
     */
    var lastEventBought: Event?
    var eventsBoughtCount: Int32 = 0
    
    var tableViewList: [ProfileSectionType] = []
    var profileType: ProfileType = .mine
    
    var fullName: String {
        var string = ""
        if let name = user?.name {
            string = name
        }
        if let lastName = user?.lastName {
            string.append(" ")
            string.append(lastName)
        }
        return string
    }
    
    var nbEvents: String {
        let strEvents = "events".localized
        return "\(nbEventsInt) " + strEvents
    }
    
    var nbEventsInt: Int {
        return Int(eventsBoughtCount) + Int(eventsCreatedCount) + Int(eventsInterestedCount)
    }
    
    init(user: User? = nil, type: ProfileType = .mine) {
        if user != nil {
            self.user = user
        } else {
            self.user = User.current()
        }
        
        self.profileType = type
        
        // Add observers to add badge when app is Active
        GRNNotif.updatedProfileImage.observe(observer: self) { [weak self] (notification) in
            self?.delegate?.didLoadData()
        }
    }
    
    deinit {
        print("deinit called - Remove observers")
        GRNNotif.updatedProfileImage.removeObserver(observer: self)
    }
    
    func loadData() {
        
        guard let user = user else { return }
        
        let group = DispatchGroup()

//        group.enter()
//        FacebookManager.shared.fetchFriendsList { [weak self] (friends, _) in
//            self?.friends = friends
//            group.leave()
//        }
        
        group.enter()
        EventManager().countEventsCreated(by: user) { [weak self] (count, _) in
            self?.eventsCreatedCount = count
            group.leave()
        }
        
        group.enter()
        EventManager().lastEventCreated(by: user) { [weak self] (lastEvent, _) in
            self?.lastEventCreated = lastEvent
            group.leave()

        }
        
        group.enter()
        InterestedEventManager().countEventsInterested(by: user) { [weak self] (count, _) in
            self?.eventsInterestedCount = count
            group.leave()

        }
        
        group.enter()
        InterestedEventManager().lastEventInterested(by: user) { [weak self] (lastEvent, _) in
            self?.lastEventInterested = lastEvent
            group.leave()

        }
        
        // show  tickets bought only for current user
        if profileType == .mine {
            group.enter()
            OrderManager().lastEventBought(by: user) { [weak self] (lastEvent, _) in
                self?.lastEventBought = lastEvent
                group.leave()
            }
            
            group.enter()
            OrderManager().countEventsBought(by: user) { [weak self] (count, _) in
                self?.eventsBoughtCount = count
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.updateData()
        }
    }
    
    func ring() -> BandType {
        return BandType.bandType(by: nbEventsInt)
    }
    
    func event(by indexPath: IndexPath, of type: EventsType) -> Event? {
        switch type {
        case .bought:
            return lastEventBought
        case .interested:
            return lastEventInterested
        case .created:
            return lastEventCreated
        }
    }
    
    func numberOfEvents(by type: EventsType) -> String {
        switch type {
        case .bought:
            return String(format: "see".localized, String(eventsBoughtCount))
        case .interested:
            return String(format: "see".localized, String(eventsInterestedCount))
        case .created:
            return String(format: "see".localized, String(eventsCreatedCount))
        }
    }
    
    func eventDetailsViewModel(by type: EventsType) -> ExpDetailViewModel {
        var event: Event?
        switch type {
        case .bought: event = lastEventBought
        case .interested: event = lastEventInterested
        case .created: event = lastEventCreated
        }
        
        if let event = event {
            return ExpDetailViewModel(event: event)
        }
        fatalError("Event select cant be nil")
    }
    
    // Call this function in every section to load in tableview
    private func updateData() {
        updateTableViewList()
        delegate?.didLoadData()
    }
}

extension ProfileViewModel {
    func numberOfRows(for section: Int) -> Int {
        return 1
    }
    
    func typeCell(for indexPath: IndexPath) -> ProfileSectionType {
        return tableViewList[indexPath.section]
    }
    
    private func updateTableViewList() {
        tableViewList.removeAll()
        
        tableViewList.append(.cover)
        
//        if let user = user, user.authType == UserAuthType.email.rawValue, user.facebookId == nil {
//            tableViewList.append(.facebookConnect)
//        } else if !friends.isEmpty && profileType == .mine {
//            tableViewList.append(.friends)
//        }
        
        if lastEventBought != nil || lastEventInterested != nil || lastEventCreated != nil {
            tableViewList.append(.section)
        }
        
        if lastEventBought != nil {
            tableViewList.append(.myTickets)
        }
        
        if lastEventInterested != nil {
            tableViewList.append(.interested)
        }
        
        // i don't know why this line here?
       // if profileType == .friend { return }
        
        if lastEventCreated != nil {
            tableViewList.append(.created)
        }
    }
}

extension ProfileViewModel {
    func reportUser(type: ReportUserType) {
        ReportUserManager().createReport(user: user, type: type) { [weak self] (_, error) in
            if let err = error {
                self?.delegate?.didFail(error: err)
            } else {
                self?.delegate?.didSuccess(msg: "Success reporting user".localized)
            }
        }
    }

}
