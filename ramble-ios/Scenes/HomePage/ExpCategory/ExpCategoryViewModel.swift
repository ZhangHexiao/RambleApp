//
//  ExpCategoryViewModel.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-15.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol ExpCategoryViewModelDelegate: class {
    func didLoadData()
    func didLoadDataEmpty()
    
    func didSuccess(msg: String)
    func didFail(error: String)
}

enum CategoryTableList: Int {
    case startingSoon
    case filter
    case home
    case empty
}

class ExpCategoryViewModel {
    
    weak var delegate: ExpCategoryViewModelDelegate?
    
    var nbSkip: Int = 0
    var eventsDict: [String: [Event]] = [:]
    var orderedSections: [String] = []
    var startingSoonEvent: Event?
    var tableViewSectionList: [CategoryTableList] = []
    var categoryName: String = "Ramble"
    
//    init(category: String) {
//       categoryName = category
//    }
    init() { } 
    func loadEvents(isSkipping: Bool = false, isRefreshing: Bool = false) {
        let skipping = isSkipping ? nbSkip : 0
        startingSoonEvent = startingSoonEvent == nil ? nil : startingSoonEvent
        let group = DispatchGroup()
        
        if !isRefreshing {
            group.enter()
            EventManager().all (skipping: skipping, pageType: "Home", category: categoryName) { [weak self] (events, error) in
                if let err = error {
                    self?.delegate?.didFail(error: err)
                    group.leave()
                    return
                }
                
                if events.isEmpty && isSkipping {
                    self?.delegate?.didLoadDataEmpty()
                } else {
                    self?.nbSkip += events.count
                    self?.sortEvents(events:events, isAppending: isSkipping)
                }
                group.leave()
            }
            
        } else {
            var eventDate: Date = Date()
            let events = eventsDict[orderedSections.first ?? ""]
            let event = events?.first
            eventDate = event?.startAt ?? Date()
            group.enter()
            EventManager().eventsBefore (date: eventDate,pageType: "Home") { [weak self] (events, error) in
                if let err = error {
                    self?.delegate?.didFail(error: err)
                    group.leave()
                    return
                }
                let finalEvents = self?.removeExisting(events: events)
                self?.sortEvents(events: finalEvents ?? [], isAppending: isRefreshing)
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.updateTableViewList()
            self?.delegate?.didLoadData()
        }
    }
    
    func selectEvent(for type: CategoryTableList, at indexPath: IndexPath) -> ExpDetailViewModel? {
        switch type {
        case .empty:  return nil

        case .home:
            let hSection = homeSection(tableSection: indexPath.section)
            guard let events = eventsDict[orderedSections[hSection]] else { return nil }
            return ExpDetailViewModel(event: events[indexPath.row])
        case  .filter: return nil
        case .startingSoon: return nil
//            guard let event = startingSoonEvent else { return nil }
//            return ExpDetailViewModel(event: event)
        }
    }
    
    func removeExisting(events: [Event]) -> [Event] {
        var allEvents: [Event] = []
        var addedEvents: [Event] = []
        eventsDict.values.forEach { allEvents.append(contentsOf: $0)}
        for event in events {
            if !allEvents.contains(event) {
                addedEvents.append(event)
            }
        }
        return addedEvents
    }
    
    func eventViewModel(at indexPath: IndexPath) -> EventViewModel {
        
        let section = homeSection(tableSection: indexPath.section)
        
        guard let events = eventsDict[orderedSections[section]] else {
            assertionFailure()
            return EventViewModel(event: Event())
        }
        
        return EventViewModel(event: events[indexPath.row])
    }
    
    func dateFormatted(for section: Int) -> String {
        return orderedSections[homeSection(tableSection: section)]
    }
    
    private func homeSection(tableSection: Int) -> Int {
        var homeSection = tableSection - 1
        if startingSoonEvent != nil {
            homeSection -= 1 }
        return  homeSection
    }
}

extension ExpCategoryViewModel {
    
    func typeCell(for indexPath: IndexPath) -> CategoryTableList {
        return tableViewSectionList[indexPath.section]
    }
    
    func numberOfSections() -> Int {
        return tableViewSectionList.count
    }
    
    func numberOfRows(for section: Int) -> Int {
        
        switch tableViewSectionList[section] {
        case .startingSoon: return 1
        case .filter: return 1
        case .empty: return 1
        case .home:
            let hSection = homeSection(tableSection: section)
            return eventsDict[orderedSections[hSection]]?.count ?? 0
        }
    }
    
    private func updateTableViewList() {
        tableViewSectionList.removeAll()
        if startingSoonEvent != nil, User.current() != nil {
            tableViewSectionList.append(.startingSoon)
        }
        tableViewSectionList.append(.filter)
        if orderedSections.isEmpty {
            tableViewSectionList.append(.empty)
            return
        } else {
            for _ in 0 ..< eventsDict.keys.count {
                tableViewSectionList.append(.home)
            }
        }
    }
    
    func seeIfEventExist() {
        if startingSoonEvent == nil, let user = User.current() {
            OrderManager().lastEventBoughtIn24h(by: user) { [weak self] (lastevent, _) in
                self?.startingSoonEvent = self?.startingSoonEvent == nil ? lastevent : self?.startingSoonEvent
                self?.updateTableViewList()
                self?.delegate?.didLoadData()
            }
        }
    }
}

// Mark - Home View Model Sort by date
extension ExpCategoryViewModel {
    private func sortEvents(events: [Event], isAppending: Bool) {
        
        if !isAppending {
            eventsDict.removeAll()
            orderedSections.removeAll()
        }
        
        let distance = RMBDistanceHelper()
        for event in events {
            
            let dateGroup = (event.startAt ?? Date()).absoluteDaysDifference(from: Date()) < 0 ? Date() : (event.startAt ?? Date())
            
            let key = RMBDateFormat.weekdayMonthDay.formatted(date: dateGroup).capitalizingFirstLetter()
            var arr = eventsDict[key]
            if arr == nil {
                arr = [event]
                orderedSections.append(key)
            } else {
                arr?.append(event)
                arr = arr?.sorted(by: {

                    let coordinates1 = ($0.coordinates?.latitude ?? 0.0,
                                        $0.coordinates?.longitude ?? 0.0)

                    let coordinates2 = ($1.coordinates?.latitude ?? 0.0,
                                        $1.coordinates?.longitude ?? 0.0)

                    return distance.distanceInMetersToUser(from: coordinates1) < distance.distanceInMetersToUser(from: coordinates2)
                })
            }
            eventsDict[key] = arr
        }
    }
}
