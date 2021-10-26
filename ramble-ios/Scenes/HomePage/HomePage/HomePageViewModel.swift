//
//  HomePageViewModel.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-05-31.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
protocol HomePageViewModelDelegate: class {
    func didLoadData()
    func didLoadDataEmpty()
    
    func didSuccess(msg: String)
    func didFail(error: String)
    func didSetNotification()
}
enum HomePageTableList {
    case header
    case filter
    case tastebuds(title: String)
    case entertainment(title: String)
    case family(title: String)
    case outdoors(title: String)
    case peopleGatherings(title: String)
    case artsCulture(title: String)
    case empty
}

class HomePageViewModel {
    
    weak var delegate: HomePageViewModelDelegate?
    
    var userLocation: LocationModel?
    var placesService: LocationService
    var coordinate:(latitude:Double,longitude:Double)?
    var city: String?
    var nbSkip: Int = 0
    var eventsDict: [String: [Event]] = [:]
    var locationAuthorization: Bool = true
    
    var expCategoryDict: [String: [Event]] = ["Tastebuds": [],"Entertainment": [], "Family": [], "Outdoors": [], "People & Gatherings": [], "Arts & Culture": []]
    var tableViewSectionList: [HomePageTableList] = []
    var countNotification: Int = 0 {
        didSet {
            delegate?.didSetNotification()
        }
    }
    
    var countMessage: Int = 0 {
        didSet {
            delegate?.didSetNotification()
        }
    }
    
    var headerEvents: [Event] = []
    
    init() {
        placesService = LocationService()
        currentLocation()
    }
    
    func currentLocation() {
        placesService.getUserLocation() { [weak self] (location) in
            guard let location = location else {
                self?.delegate?.didFail(error: RMBError.locationCantRetrieceUsersLocation.localizedDescription)
                return
            }
            self?.userLocation = location
        }
    }
    
    func getSetLocation(coordinate:(latitude:Double,longitude:Double)?) {
        placesService.getResetLocation(coordinateReset: coordinate) { [weak self] (location) in
            guard let location = location else {
                self?.delegate?.didFail(error:
                    RMBError.locationCantRetrieceUsersLocation.localizedDescription)
                return
            }
            self?.userLocation = location
        }
    }
    
    
    func loadEvents(isSkipping: Bool = false, isRefreshing: Bool = false, coordinate:(latitude:Double,longitude:Double)? = nil) {
        let skipping = isSkipping ? nbSkip : 0
        let group = DispatchGroup()
        if locationAuthorization == true || coordinate != nil {
        group.enter()
        EventManager().all (skipping: skipping, coordinate:coordinate, pageType: "Home") { [weak self] (events, error) in
            if let err = error {
                self?.delegate?.didFail(error: err)
                group.leave()
                return
            }
            
            if events.isEmpty && isSkipping {
                self?.delegate?.didLoadDataEmpty()
            } else {
                self?.nbSkip += events.count
                self?.sortExps(events:events, isAppending: isSkipping)
            }
            group.leave()
        }
        }
        // load HEADER EVENT
        group.enter()
        EventManager().getHeaderEvent(){[weak self] (events, error) in
            if let err = error {
                self?.delegate?.didFail(error: err)
                return
            }
            self?.headerEvents = events
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            self?.updateTableViewList()
            self?.delegate?.didLoadData()
        }
    }
    
    private func updateTableViewList() {
        tableViewSectionList.removeAll()
        tableViewSectionList.append(.header)
        tableViewSectionList.append(.filter)
        let allExps = expCategoryDict.compactMap { $0.value }.flatMap { $0 }
        if allExps.count == 0 {
           tableViewSectionList.append(.empty)
        }
        
        for categoryExp in expCategoryDict{
            switch categoryExp.key {
            case "Tastebuds":
                if expCategoryDict["Tastebuds"]!.count > 0 {
                    tableViewSectionList.append(.tastebuds(title: "Tastebuds"))
                }
            case "Entertainment":
                if expCategoryDict["Entertainment"]!.count > 0  {
                    tableViewSectionList.append(.entertainment(title: "Entertainment"))
                }
            case "Family":
                if expCategoryDict["Family"]!.count > 0  {
                    tableViewSectionList.append(.family(title: "Family"))
                }
            case "Outdoors":
                if expCategoryDict["Outdoors"]!.count > 0  {
                    tableViewSectionList.append(.outdoors(title: "Outdoors"))
                }
            case "People & Gatherings":
                if expCategoryDict["People & Gatherings"]!.count > 0  {
                    tableViewSectionList.append(.peopleGatherings(title: "People & Gatherings"))
                }
            case "Arts & Culture":
                if expCategoryDict["Arts & Culture"]!.count > 0  {
                    tableViewSectionList.append(.artsCulture(title: "Arts & Culture"))
                }
            default:
                return
            }
        }
    }
    
    func fetchUnreadNotification() {
        NotificationManager().countUnreadNotification { [weak self] (count) in
            self?.countNotification = count
        }
    }
    
    func fetchUnreadMessage() {
        NotificationManager().countUnreadMessage() { [weak self] (count) in
            self?.countMessage = count
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
}

// Mark - Home View Model Sort by date
extension HomePageViewModel {
    
    private func sortExps(events: [Event], isAppending: Bool, coordinate:(latitude:Double,longitude:Double)? = nil) {
        
         expCategoryDict.removeAll()
        var eventsToSort: [Event] = []
        let distance = RMBDistanceHelper()
        
        if coordinate == nil
        {
           eventsToSort = events.sorted(by: {
            
            let coordinates1 = ($0.coordinates?.latitude ?? 0.0,
                                $0.coordinates?.longitude ?? 0.0)
            
            let coordinates2 = ($1.coordinates?.latitude ?? 0.0,
                                $1.coordinates?.longitude ?? 0.0)
            
            return distance.distanceInMetersToUser(from: coordinates1) < distance.distanceInMetersToUser(from: coordinates2)
        })
        } else{
           eventsToSort = events
        }
        expCategoryDict = ["Tastebuds": [],"Entertainment": [], "Family": [], "Outdoors": [], "People & Gatherings": [], "Arts & Culture": []]
        
        for event in eventsToSort {
            // FIXME: case "art""music""sport""food""other", those should change as the Categories in database
            switch event.category{
            case "art":
                expCategoryDict["Tastebuds"]?.append(event)
            case "music":
                expCategoryDict["Entertainment"]?.append(event)
            case "sports":
                expCategoryDict["Family"]?.append(event)
            case "food":
                expCategoryDict["Outdoors"]?.append(event)
            case "other":
                expCategoryDict["People & Gatherings"]?.append(event)
            default:
                expCategoryDict["Arts & Culture"]?.append(event)
            }
        }
    }
}

extension HomePageViewModel {
    func typeCell(for indexPath: IndexPath) -> HomePageTableList {
        return tableViewSectionList[indexPath.section]
    }
    
    func numberOfSections() -> Int {
        return tableViewSectionList.count
    }
    
    func numberOfRows(for section: Int) -> Int {
        switch tableViewSectionList[section] {
        case .header, .filter, .tastebuds, .entertainment, .family, .outdoors,
             .peopleGatherings, .artsCulture: return 1
        case .empty: return 1
        }
    }
    
}
