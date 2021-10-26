//
//  SearcheventViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-18.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol SearcheventViewModelDelegate: class {
    func didLoadData()
    func didLoadDataEmpty()
    
    func didSuccess(msg: String)
    func didFail(error: String)
}

enum SearcheventTableList: Int {
    case notSearchResult
    case filter
    case home
    case empty
}

class SearcheventViewModel {
    
    weak var delegate: SearcheventViewModelDelegate?
    
    var nbSkip: Int = 0
    var eventsDict: [String: [Event]] = [:]
    var orderedSections: [String] = []
    var tableViewSectionList: [SearcheventTableList] = []
    var searchTimer2: Timer?
    var lastSearch: String?
    var testBeforeFilter: String = ""
    var coordinate:(latitude:Double,longitude:Double)?
//    ====Add dynamic city label===============
    var placesService: LocationService
    var userLocation: LocationModel?
    let tabBarController = UITabBarController()
    
    
    init() {
        placesService = LocationService()
        currentLocation()
//        FacebookManager.shared.fetchFriendsList()
    }
    
    func currentLocation() {
        placesService.getResetLocation(coordinateReset: self.coordinate) { [weak self] (location) in
            guard let location = location else {
                self?.delegate?.didFail(error: RMBError.locationCantRetrieceUsersLocation.localizedDescription)
                return
            }
            self?.userLocation = location
        }
    }
    
    func getSetLocation(coordinate:(latitude:Double,longitude:Double)) {
        placesService.getResetLocation(coordinateReset: coordinate) { [weak self] (location) in
            guard let location = location else {
                self?.delegate?.didFail(error: RMBError.locationCantRetrieceUsersLocation.localizedDescription)
                return
            }
            self?.userLocation = location
        }
    }
    
    func loadEvents(isSkipping: Bool = false, isRefreshing: Bool = false, inputText:String = "", coordinate:(latitude:Double,longitude:Double)? = nil) {
        self.lastSearch = inputText
        let skipping = isSkipping ? nbSkip : 0
        let group = DispatchGroup()
        
        if !isRefreshing {
            group.enter()
            EventManager().all (skipping: skipping, coordinate:coordinate, pageType:"Search") { [weak self] (events, error) in
                if let err = error {
                    self?.delegate?.didFail(error: err)
                    group.leave()
                    return
                }
                
                if events.isEmpty && isSkipping {
                    self?.delegate?.didLoadDataEmpty()
                } else {
                    self?.nbSkip += events.count
                    self?.sortEvents(events, isAppending: isSkipping, searchText:inputText)
                }
                group.leave()
            }
            
//            group.enter()
//            InterestedEventManager().startingSoon { [weak self] (event, error) in
//                self?.startingSoonEvent = event == nil ? self?.startingSoonEvent : event
//                group.leave()
//            }
        } else {
            var eventDate: Date = Date()
            let events = eventsDict[orderedSections.first ?? ""]
            let event = events?.first
            eventDate = event?.startAt ?? Date()
            group.enter()
            EventManager().eventsBefore (date: eventDate,pageType: "Search") { [weak self] (events, error) in
                if let err = error {
                    self?.delegate?.didFail(error: err)
                    group.leave()
                    return
                }
                let finalEvents = self?.removeExisting(events: events)
                self?.sortEvents(finalEvents ?? [], isAppending: isRefreshing, searchText:inputText)
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.updateTableViewList()
            self?.delegate?.didLoadData()
        }
    }

    func selectEvent(for type: SearcheventTableList, at indexPath: IndexPath) -> ExpDetailViewModel? {
        switch type {
        case .notSearchResult, .empty, .filter: return nil
        case .home:
            let hSection = homeSection(tableSection: indexPath.section)
            guard let events = eventsDict[orderedSections[hSection]] else { return nil }
            return ExpDetailViewModel(event: events[indexPath.row])
//        case .startingSoon:
//            guard let event = startingSoonEvent else { return nil }
//            return EventDetailsViewModel(event: event)
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
    
//    func eventViewModel(at indexPath: IndexPath) -> ExpDetailViewModel {
//        
//        let section = homeSection(tableSection: indexPath.section)
//        
//        guard let events = eventsDict[orderedSections[section]] else {
//            assertionFailure()
//            return ExpDetailViewModel(event: Event())
//        }
//        
//        return ExpDetailViewModel(event: events[indexPath.row])
//    }
    
    func dateFormatted(for section: Int) -> String {
        return orderedSections[homeSection(tableSection: section)]
    }
    
    private func homeSection(tableSection: Int) -> Int {
        let homeSection = tableSection - 1
        return homeSection
    }
}

extension SearcheventViewModel {
    
    func typeCell(for indexPath: IndexPath) -> SearcheventTableList {
        return tableViewSectionList[indexPath.section]
    }
    
    func numberOfSections() -> Int {
        return tableViewSectionList.count
    }
    
    func numberOfRows(for section: Int) -> Int {
        
        switch tableViewSectionList[section] {
        case .notSearchResult: return 1
        case .filter: return 1
        case .empty: return 1
        case .home:
            let hSection = homeSection(tableSection: section)
            return eventsDict[orderedSections[hSection]]?.count ?? 0
        }
    }
    
    private func updateTableViewList() {
        tableViewSectionList.removeAll()
//        if startingSoonEvent != nil, User.current() != nil {
//            tableViewSectionList.append(.startingSoon)
//        }
        tableViewSectionList.append(.filter)
        
        if orderedSections.isEmpty {
            tableViewSectionList.append(.notSearchResult)
            return
        } else {
            for _ in 0 ..< eventsDict.keys.count {
                tableViewSectionList.append(.home)
            }
        }
    }
    
    func seeIfEventExist() {
        if let user = User.current() {
            OrderManager().lastEventBoughtIn24h(by: user) { [weak self] (lastevent, _) in
//                self?.startingSoonEvent = self?.startingSoonEvent == nil ? lastevent : self?.startingSoonEvent
                self?.updateTableViewList()
                self?.delegate?.didLoadData()
            }
        }
    }
    
    func getIsSerachedEvent(events:[Event],searchBarTextArr:[String])-> [Event]{
        var eventsSearched = [Event]()
        for event in events{
        let name = event.name == nil ? "" : event.name!.lowercased()
        let desc = event.desc == nil ? "" : event.desc!.lowercased()
        if searchBarTextArr.contains(where: name.contains)||searchBarTextArr.contains(where: desc.contains)
        {
            eventsSearched.append(event)
        }
        }
        return eventsSearched
    }
}

// Mark - Searchevent View Model Sort by date
extension SearcheventViewModel {
    
    private func sortEvents(_ events: [Event], isAppending: Bool, searchText:String, coordinate:(latitude:Double,longitude:Double)? = nil) {
//      =Seperate the input text in to different strings by blank=
        let searchText = searchText.lowercased()
        let searchTextArr = searchText.components(separatedBy: " ")
        var eventsToDisplay = [Event]()
//      =======Search the Events======
        let eventsSearched = getIsSerachedEvent(events:events,searchBarTextArr:searchTextArr)
//      ===========================
        if !isAppending {
            eventsDict.removeAll()
            orderedSections.removeAll()
        }
        let distance = RMBDistanceHelper()
        
        if (self.coordinate != nil && searchText == "")
        {eventsToDisplay =  events}
        else{
            eventsToDisplay = eventsSearched
        }
          for event in eventsToDisplay {
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
