////
////  HomeViewModel.swift
////  ramble-ios
////  Hexiao Zhang
////  Created by Ramble Technologies on 2020-06-15.
////  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
////
//import Foundation
//
//protocol HomeViewModelDelegate: class {
//    func didLoadData()
//    func didLoadDataEmpty()
//    
//    func didSuccess(msg: String)
//    func didFail(error: String)
//    func didSetNotification()
//}
//
//enum HomeTableList: Int {
//    case startingSoon
//    case filter
//    case home
//    case empty
//}
//
//class HomeViewModel {
//    
//    weak var delegate: HomeViewModelDelegate?
//    
//    var nbSkip: Int = 0
//    var eventsDict: [String: [Event]] = [:]
//    var orderedSections: [String] = []
//
//    var startingSoonEvent: Event?
//
//    var tableViewSectionList: [HomeTableList] = []
//    
//    var countNotification: Int = 0 {
//        didSet {
//            delegate?.didSetNotification()
//        }
//    }
//    
//    var countMessage: Int = 0 {
//        didSet {
//            delegate?.didSetNotification()
//        }
//    }
//    
//    init() {
////        FacebookManager.shared.fetchFriendsList()
//    }
//    
//    func loadEvents(isSkipping: Bool = false, isRefreshing: Bool = false) {
//        let skipping = isSkipping ? nbSkip : 0
//        startingSoonEvent = startingSoonEvent == nil ? nil : startingSoonEvent
//        let group = DispatchGroup()
//        
//        if !isRefreshing {
//            group.enter()
//            EventManager().all (skipping: skipping, pageType: "Home") { [weak self] (events, error) in
//                if let err = error {
//                    self?.delegate?.didFail(error: err)
//                    group.leave()
//                    return
//                }
//                
//                if events.isEmpty && isSkipping {
//                    self?.delegate?.didLoadDataEmpty()
//                } else {
//                    self?.nbSkip += events.count
//                    self?.sortEvents(events:events, isAppending: isSkipping)
//                }
//                group.leave()
//            }
//            
//            group.enter()
//            InterestedEventManager().startingSoon { [weak self] (event, error) in
//                self?.startingSoonEvent = event == nil ? self?.startingSoonEvent : event
//                group.leave()
//            }
//        } else {
//            var eventDate: Date = Date()
//            let events = eventsDict[orderedSections.first ?? ""]
//            let event = events?.first
//            eventDate = event?.startAt ?? Date()            
//            group.enter()
//            EventManager().eventsBefore (date: eventDate,pageType: "Home") { [weak self] (events, error) in
//                if let err = error {
//                    self?.delegate?.didFail(error: err)
//                    group.leave()
//                    return
//                }
//                let finalEvents = self?.removeExisting(events: events)
//                self?.sortEvents(events: finalEvents ?? [], isAppending: isRefreshing)
//                group.leave()
//            }
//        }
//        
//        group.notify(queue: .main) { [weak self] in
//            self?.updateTableViewList()
//            self?.delegate?.didLoadData()
//        }
//    }
//    
//    func updateStartingSoon() {
//        InterestedEventManager().startingSoon { [weak self] (event, error) in
//            guard let event = event else { return }
//            self?.startingSoonEvent = event
//            self?.updateTableViewList()
//            self?.delegate?.didLoadData()
//        }
//    }
//    
//    func fetchUnreadNotification() {
//        NotificationManager().countUnreadNotification { [weak self] (count) in
//            self?.countNotification = count
//        }
//    }
//    
//    func fetchUnreadMessage() {
//        NotificationManager().countUnreadMessage() { [weak self] (count) in
//            self?.countMessage = count
//        }
//    }
//    
//    func selectEvent(for type: HomeTableList, at indexPath: IndexPath) -> EventDetailsViewModel? {
//        switch type {
//        case .empty, .filter: return nil
//        case .home:
//            let hSection = homeSection(tableSection: indexPath.section)
//            guard let events = eventsDict[orderedSections[hSection]] else { return nil }
//            return EventDetailsViewModel(event: events[indexPath.row])
//        case .startingSoon:
//            guard let event = startingSoonEvent else { return nil }
//            return EventDetailsViewModel(event: event)
//        }
//    }
//    
//    func removeExisting(events: [Event]) -> [Event] {
//        var allEvents: [Event] = []
//        var addedEvents: [Event] = []
//        eventsDict.values.forEach { allEvents.append(contentsOf: $0)}
//        for event in events {
//            if !allEvents.contains(event) {
//                addedEvents.append(event)
//            }
//        }
//        return addedEvents
//    }
//    
//    func eventViewModel(at indexPath: IndexPath) -> EventViewModel {
//        
//        let section = homeSection(tableSection: indexPath.section)
//        
//        guard let events = eventsDict[orderedSections[section]] else {
//            assertionFailure()
//            return EventViewModel(event: Event())
//        }
//        
//        return EventViewModel(event: events[indexPath.row])
//    }
//    
//    func dateFormatted(for section: Int) -> String {
//        return orderedSections[homeSection(tableSection: section)]
//    }
//    
//    private func homeSection(tableSection: Int) -> Int {
//        var homeSection = tableSection - 1
//        
//        if startingSoonEvent != nil {
//            homeSection -= 1
//        }
//        return homeSection
//    }
//}
//
//extension HomeViewModel {
//    
//    func typeCell(for indexPath: IndexPath) -> HomeTableList {
//        return tableViewSectionList[indexPath.section]
//    }
//    
//    func numberOfSections() -> Int {
//        return tableViewSectionList.count
//    }
//    
//    func numberOfRows(for section: Int) -> Int {
//        
//        switch tableViewSectionList[section] {
//        case .startingSoon: return 1
//        case .filter: return 1
//        case .empty: return 1
//        case .home:
//            let hSection = homeSection(tableSection: section)
//            return eventsDict[orderedSections[hSection]]?.count ?? 0
//        }
//    }
//    
//    private func updateTableViewList() {
//        tableViewSectionList.removeAll()
//        
//        if startingSoonEvent != nil, User.current() != nil {
//            tableViewSectionList.append(.startingSoon)
//        }
//        
//        tableViewSectionList.append(.filter)
//        
//        if orderedSections.isEmpty {
//            tableViewSectionList.append(.empty)
//            return
//        } else {
//            for _ in 0 ..< eventsDict.keys.count {
//                tableViewSectionList.append(.home)
//            }
//        }
//    }
//    
//    func seeIfEventExist() {
//        if startingSoonEvent == nil, let user = User.current() {
//            OrderManager().lastEventBoughtIn24h(by: user) { [weak self] (lastevent, _) in
//                self?.startingSoonEvent = self?.startingSoonEvent == nil ? lastevent : self?.startingSoonEvent
//                self?.updateTableViewList()
//                self?.delegate?.didLoadData()
//            }
//        }
//    }
//}
//
//// Mark - Home View Model Sort by date
//extension HomeViewModel {
//    
//    //  "Friday, Nov 09": [Event]
//    //  "Tuesday, Nov 13": [Event]
//    // ...
//    
//    private func sortEvents(events: [Event], isAppending: Bool) {
//        
//        if !isAppending {
//            eventsDict.removeAll()
//            orderedSections.removeAll()
//        }
//        
//        let distance = RMBDistanceHelper()
//        for event in events {
//            
//            let dateGroup = (event.startAt ?? Date()).absoluteDaysDifference(from: Date()) < 0 ? Date() : (event.startAt ?? Date())
//            
//            let key = RMBDateFormat.weekdayMonthDay.formatted(date: dateGroup).capitalizingFirstLetter()
//            var arr = eventsDict[key]
//            if arr == nil {
//                arr = [event]
//                orderedSections.append(key)
//            } else {
//                arr?.append(event)
//                arr = arr?.sorted(by: {
//
//                    let coordinates1 = ($0.coordinates?.latitude ?? 0.0,
//                                        $0.coordinates?.longitude ?? 0.0)
//
//                    let coordinates2 = ($1.coordinates?.latitude ?? 0.0,
//                                        $1.coordinates?.longitude ?? 0.0)
//
//                    return distance.distanceInMetersToUser(from: coordinates1) < distance.distanceInMetersToUser(from: coordinates2)
//                })
//            }
//            eventsDict[key] = arr
//        }
//    }
//}
