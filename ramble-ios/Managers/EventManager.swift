//
//  EventManager.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-5-19.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

class EventManager {
    
    typealias EventErrorHandler = ((_ error: String?) -> Void)?
    typealias EventHandler = ((_ event: Event?, _ error: String?) -> Void)?
    typealias ListEventsHandler = ((_ events: [Event], _ error: String?) -> Void)?
    typealias ListEventsCountHandler = ((_ nbEvents: Int32, _ error: String?) -> Void)?
    var eventToReturn: Event = Event()
    /**
        Save a new event into parse.
     ```
     ```
     - parameter event: Object Event.
     - parameter eventType: NewEventType.
     - parameter completion: Return error if any
     - returns: void.
     */
    func save(event: Event, eventType: NewEventType = .new, _ completion: EventErrorHandler = nil) {
        event.isEnabled = true
        event.hasBadge = false
        event.eventStartingSent = false
        event.eventStatus = EventStatus.active.rawValue
        event.eventStatusEnum = .active
        event.coordinates = PFGeoPoint(latitude: event.lat, longitude: event.lng)
        event.image = ImageHelper.imageToData(image: event.cachedImage)
        
        event.saveInBackground { (_, error) in
            completion?(error?.localizedDescription)
        }
    }
    
    /**
     Delete a new event from parse if no one has interested in
     ```
     ```
     - parameter event: Object Event.
     - parameter completion: Return error if any
     - returns: void.
     */
    func delete(event: Event, _ completion: EventErrorHandler = nil) {
        InterestedEventManager().hasEventBeenInterested(event: event) { (interested, error) in
            if let err = error {
                completion?(err)
                return
            }
            if interested != nil {
                completion?(RMBError.hasBeenInterested.localizedDescription)
                return
            }
            event.deleteInBackground(block: { (hasDeleted, error) in
                if let err = error {
                    completion?(err.localizedDescription)
                    return
                }
                completion?(nil)
            })
        }
    }
    
    /**
     Cancel an event
     ```
     ```
     - parameter event: Object Event.
     - parameter completion: Return error if any
     - returns: void.
     */
    func cancel(event: Event, _ completion: EventHandler = nil) {
        event.eventStatus = EventStatus.cancelled.rawValue
        event.eventStatusEnum = .cancelled
        event.saveInBackground { (_, error) in
            completion?(event, error?.localizedDescription)
        }
    }
    
    /**
     We fetch associated info with events:
     If user has bought any tickets
     If it has been interested by user
     Common friends going to the event
     ```
     ```
     - parameter event: Event to be fetched
     - parameter completion: - event fetched - error string if any
     - returns: void.
     */
    func fetchInfo(from event: Event, _ completion: EventHandler = nil) {
        firstly {
            when(fulfilled: InterestedEventManager().hasEventBeenInterested(event: event),
                             TicketBoughtManager().getMyTickets(for: event),
//  currently donot get friends information                self.friendsInterested(in: event),
                ReviewManager().getReviewPromise(for: event)
            )
        }.done { hasBeenInterested, myTickets, reviews in
            event.hasEventBeenInterested = hasBeenInterested
            event.myTickets = myTickets.isEmpty ? nil : myTickets
            event.reviews = reviews.isEmpty ? nil : reviews
            completion?(event, nil)
        }.catch { (error) in
            AuthManager.logoutIfInvalidSession(error: error)
            completion?(event, error.localizedDescription)
        }
    }
    
    /**
     Retrieve all events from the server
     ```
     We check if any filter is applied
     ```
     - parameter completion: list of events, error if any
     - parameter skipping: number to skip for pagination
     - returns: void.
     */
    func all(skipping: Int = 0, coordinate:(latitude:Double, longitude:Double)? = nil, pageType: String, category: String? = nil, _ completion: ListEventsHandler = nil) {
       
        let query = Event.safeQuery()
        query?.order(byAscending: Event.Properties.startAt)
        query?.whereKey(Event.Properties.endAt, greaterThanOrEqualTo: Date())
        query?.skip = skipping
        query?.limit = 20
        
        if category != nil {
        let categories = [category]
            query?.whereKey(Event.Properties.category, containedIn: categories as [Any])
        }
        
        if coordinate != nil {
            let locationSet = PFGeoPoint()
            locationSet.latitude = coordinate!.latitude
            locationSet.longitude = coordinate!.longitude
            query?.whereKey(Event.Properties.coordinates, nearGeoPoint: locationSet, withinKilometers: Double(Const.radius))
        }
        else {
        if let geoPoint = User.current()?.location {
            query?.whereKey(Event.Properties.coordinates, nearGeoPoint: geoPoint, withinKilometers: Double(Const.radius))
        }
        }
  // ==Assign the filter to the filterTuple,check if it is search page==
        var filterTuple = FilterManager().loadFilterHome()
        if pageType == "Search"
        {filterTuple = FilterManager().loadFilterSearch()
        }
        
        if let startAt = filterTuple.fromDate {
  // Filter dates starting from the selected filter
            query?.whereKey(Event.Properties.startAt, greaterThanOrEqualTo: startAt)
        }
        
        if let endAt = filterTuple.toDate {
            query?.whereKey(Event.Properties.endAt, lessThanOrEqualTo: endAt)
        } else {
            // We don't want to show past events
            query?.whereKey(Event.Properties.endAt, greaterThanOrEqualTo: Date())
        }
        
        if let categories = filterTuple.categories, !categories.isEmpty {
            query?.whereKey(Event.Properties.category, containedIn: categories)
        }
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if let err = error {
                AuthManager.logoutIfInvalidSession(error: error)
                completion?([], err.localizedDescription)
                return
            }
            
            guard let events = objects as? [Event] else {
                completion?([], RMBError.couldntFetchEvent.localizedDescription)
                return
            }
            
            completion?(events, nil)
        })
    }
    
    // for the new home page
        func getHeaderEvent(coordinate:(latitude:Double, longitude:Double)? = nil, _ completion: ListEventsHandler = nil) {
           
            let query = Event.safeQuery()
            query?.order(byAscending: Event.Properties.startAt)
            query?.whereKey(Event.Properties.endAt, greaterThanOrEqualTo: Date())
            query?.whereKey(Event.Properties.headerEvent, greaterThanOrEqualTo: 1)
            query?.limit = 20
            query?.findObjectsInBackground(block: { (objects, error) in
                if let err = error {
                    AuthManager.logoutIfInvalidSession(error: error)
                    completion?([], err.localizedDescription)
                    return
                }
                
                guard let events = objects as? [Event] else {
                    completion?([], RMBError.couldntFetchEvent.localizedDescription)
                    return
                }
                
                completion?(events, nil)
            })
        }
//==================================
    
    func eventsBefore(date: Date, pageType: String, category: String? = nil, _ completion: ListEventsHandler = nil) {
        
        let query = Event.safeQuery()
        query?.order(byAscending: Event.Properties.startAt)
        query?.whereKey(Event.Properties.endAt, greaterThanOrEqualTo: Date())
        query?.whereKey(Event.Properties.startAt, lessThanOrEqualTo: date)
        query?.limit = 20
        
        if category != nil {
        let categories = [category]
        query?.whereKey(Event.Properties.category, containedIn: categories as [Any])
        }
        
        if let geoPoint = User.current()?.location {
            query?.whereKey(Event.Properties.coordinates, nearGeoPoint: geoPoint, withinKilometers: Double(Const.radius))
        }
        
        var filterTuple = FilterManager().loadFilterHome()
        if pageType == "Search"
        {  
            filterTuple = FilterManager().loadFilterSearch()}
        
        if let startAt = filterTuple.fromDate {
            // Filter dates starting from the selected filter
            query?.whereKey(Event.Properties.startAt, greaterThanOrEqualTo: startAt)
        }
        
        if let endAt = filterTuple.toDate {
            query?.whereKey(Event.Properties.endAt, lessThanOrEqualTo: endAt)
        } else {
            // We don't want to show past events
            query?.whereKey(Event.Properties.endAt, greaterThanOrEqualTo: Date())
        }
        
        if let categories = filterTuple.categories, !categories.isEmpty {
            query?.whereKey(Event.Properties.category, containedIn: categories)
        }
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if let err = error {
                AuthManager.logoutIfInvalidSession(error: error)
                completion?([], err.localizedDescription)
                return
            }
            
            guard let events = objects as? [Event] else {
                completion?([], RMBError.couldntFetchEvent.localizedDescription)
                return
            }
            
            completion?(events, nil)
        })
    }
    /**
     Retrieve all events for the map
     ```
     ```
     - parameter centerCoordinates: Tuple containing latitude and longitude as Double
     - parameter completion: list of events, error if any
     - returns: void.
     */
    func allForMap(with centerCoordinates: (lat: Double, lng: Double), _ completion: ListEventsHandler = nil) {
        
        let query = Event.safeQuery()
        
        // Display events which are currently happening (between start and end time)
        query?.whereKey(Event.Properties.startAt, lessThanOrEqualTo: Date())
        query?.whereKey(Event.Properties.endAt, greaterThanOrEqualTo: Date())
        query?.limit = 1000

        // given coordinates
        let coordinates = PFGeoPoint(latitude: centerCoordinates.lat, longitude: centerCoordinates.lng)
        
        query?.whereKey(Event.Properties.coordinates,
                        nearGeoPoint: coordinates,
                        withinKilometers: 10)
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if let err = error {
                completion?([], err.localizedDescription)
                return
            }
            
            guard let events = objects as? [Event] else {
                completion?([], "Couldn't fetch events".localized)
                return
            }
            
            completion?(events, nil)
        })
    }
}

// MARK: - Methods dealing with events created by user
extension EventManager {
    func lastEventCreated(by user: User, _ completion: EventHandler = nil) {
        
        let query = Event.query()
        query?.includeKey(Event.Properties.owner)
        query?.limit = 1000
        query?.whereKey(Event.Properties.owner, equalTo: user)
        query?.whereKey(Event.Properties.isEnabled, equalTo: true)
        query?.order(byDescending: Event.Properties.createdAt)
        
        query?.getFirstObjectInBackground(block: { (object, error) in
            completion?(object as? Event, error?.localizedDescription)
        })
    }
    
    func allEventsCreated(by user: User, _ completion: ListEventsHandler = nil) {
        
        let query = Event.query()
        query?.includeKey(Event.Properties.owner)
        query?.limit = 1000
        query?.whereKey(Event.Properties.owner, equalTo: user)
        query?.whereKey(Event.Properties.isEnabled, equalTo: true)
        query?.whereKey(Event.Properties.hasBadge, equalTo: false)
        query?.order(byDescending: Event.Properties.startAt)
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if let err = error {
                completion?([], err.localizedDescription)
                return
            }
            
            guard let events = objects as? [Event] else {
                completion?([], RMBError.couldntFetchEvent.localizedDescription)
                return
            }
            
            completion?(events, nil)
        })
    }
    
    func countEventsCreated(by user: User, _ completion: ListEventsCountHandler = nil) {
        let query = Event.query()
        query?.whereKey(Event.Properties.owner, equalTo: user)
        query?.whereKey(Event.Properties.isEnabled, equalTo: true)

        query?.countObjectsInBackground(block: { (nbEvents, error) in
            AuthManager.logoutIfInvalidSession(error: error)
            completion?(nbEvents, error?.localizedDescription)
        })
    }
}

extension EventManager {
    func getAllRelatedEvents( _ completion: ListEventsHandler = nil) {
        
        PFCloud.callFunction(inBackground: "allRelatedEvents", withParameters: nil) { result, error in
            print(result ?? "result")
            print(error?.localizedDescription ?? " allRelatedEvents SUCCESS")
            
            guard let events = result as? [Event] else {
                completion?([], RMBError.unknown.localizedDescription)
                return
            }
            
            completion?(events, nil)
        }
    }
    
//    func friendsInterested(in event: Event) -> Promise<[User]> {
//
//        return Promise { seal in
//            PFCloud.callFunction(inBackground: "friendsLikedEvent", withParameters: ["eventId": event.objectId ?? ""]) { result, error in
//                print(error?.localizedDescription ?? " friendsLikedEvent SUCCESS")
//                seal.fulfill((result as? [User]) ?? [])
//            }
//        }
//    }
}

extension EventManager {
    func updateAverageStar(event: Event, _ completion: EventErrorHandler = nil){
        var sum: Int = 0
        ReviewManager().getAllExperienceReview(event: event) {(reviews, error) in
            let numOfReviews = reviews.count
            for review in reviews {
                sum  = review.star + sum
            }
            let starAverage = sum/numOfReviews
            let starAverageFormat =  String(format: "%.2f", starAverage)
            event.reviewReceived = event.reviewReceived + 1
            event.averageStar = starAverageFormat
            event.saveInBackground {(_, error) in
                if let error = error{
                    completion?(error.localizedDescription)}
            }
        }
    }
}

extension EventManager {
    func getEventBaseOnId(Id: String, _ completion: ListEventsHandler = nil) {
         let query = Event.query()
         query?.limit = 1000
         query?.whereKey("objectId", equalTo: Id)
         query?.findObjectsInBackground(block: { (objects, error) in
             if let err = error {
                 completion?([], err.localizedDescription)
                 return
             }
             guard let events = objects as? [Event] else {
                 completion?([], RMBError.couldntFetchEvent.localizedDescription)
                 return
             }
             completion?(events, nil)
         })
    }
    
}//end of extension
