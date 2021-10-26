//
//  InterestedEventManager.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import PromiseKit

class InterestedEventManager {
    
    typealias InterestedEventHandler = ((_ interestedEvent: InterestedEvent?, _ error: String?) -> Void)?
    
    /**
     Toggle the interested feature of an event
     ```
      We check if user has interested in an event.
     ```
     - parameter event: Object Event.
     - parameter completion: InterestedEventHandler
     - returns: void.
     */
    func toggleInterestedEvent(event: Event, _ completion: InterestedEventHandler = nil) {
        hasEventBeenInterested(event: event) { (interestedEvent, error) in
            if let err = error {
                completion?(nil, err.localized)
                return
            }
            
            if let interestedEvent = interestedEvent {
                self.removeInterestedEvent(interestedEvent: interestedEvent, { (interested, error) in
                    completion?(interested, error)
                })
            } else {
                self.createInterestedEvent(event: event, { (interested, error) in
                    completion?(interested, error)
                })
            }
        }
    }
    
    /**
     Mark an event as interested by creating an object in database
     ```
     ```
     - parameter event: Object Event.
     - parameter completion: InterestedEventHandler
     - returns: void.
     */
    private func createInterestedEvent(event: Event, _ completion: InterestedEventHandler = nil) {
        
        guard let user = User.current() else {
            completion?(nil, RMBError.unknown.localizedDescription)
            return
        }
        
        let interestedEvent = InterestedEvent()
        interestedEvent.isEnabled = true
        interestedEvent.user = user
        interestedEvent.event = event
        interestedEvent.saveInBackground(block: { (_, error) in
            /// Send push notification to friends if available
//            PushNotificationManager().sendPushNotificationToFriends(for: event)
            
            completion?(interestedEvent, error?.localizedDescription)
        })
    }
    
    /**
     Unmark an event as interested by deleting the object in database
     ```
     ```
     - parameter event: Object Event.
     - parameter completion: InterestedEventHandler
     - returns: void.
     */
    func removeInterestedEvent(interestedEvent: InterestedEvent, _ completion: InterestedEventHandler = nil) {
        interestedEvent.deleteInBackground { (hasDeleted, error) in
            completion?(hasDeleted ? nil : interestedEvent, error?.localizedDescription)
        }
    }
    
    /**
     Remove all rows of user interested given an event
     ```
     We use this method after an order being success created.
     ```
     - parameter event: Object Event.
     - parameter completion: InterestedEventHandler
     - returns: void.
     */
    
    func removeInterestedEvent(event: Event, _ completion: InterestedEventHandler = nil) {
        guard let user = User.current() else { return }
        
        let query = InterestedEvent.safeQuery()
        query?.limit = 1000
        query?.whereKey(InterestedEvent.Properties.user, equalTo: user)
        query?.whereKey(InterestedEvent.Properties.event, equalTo: event)
        query?.findObjectsInBackground(block: { (objects, error) in
            if let objects = objects {
                for object in objects {
                    object.deleteEventually()
                }
            }
        })
    }
    
    /**
     Check if an event is interested by the current user
     ```
     ```
     - parameter event: Object Event.
     - parameter completion: InterestedEventHandler
     - returns: void.
     */
    func hasEventBeenInterested(event: Event, _ completion: InterestedEventHandler = nil) {
        
        guard let user = User.current() else {
            return
        }
        
        let query = InterestedEvent.query()
        query?.limit = 1000
        query?.whereKey(InterestedEvent.Properties.isEnabled, equalTo: true)
        query?.whereKey(InterestedEvent.Properties.user, equalTo: user)
        query?.whereKey(InterestedEvent.Properties.event, equalTo: event)
        
        query?.getFirstObjectInBackground(block: { (object, _) in
            completion?(object as? InterestedEvent, nil)
        })
    }
    
    /**
     Check if an event is interested by the current user
     ```
     ```
     - parameter event: Object Event.
     - returns: Promise<Bool>.
     */
    func hasEventBeenInterested(event: Event) -> Promise<Bool> {
        return Promise { seal in
            
            if event.owner == User.current() {
                seal.fulfill(true)
                return
            }
            hasEventBeenInterested(event: event, { (interestedEvent, _) in
                seal.fulfill(interestedEvent != nil)
            })
        }
    }
    
    /**
     Retrieve the event that an user has marked as interested in the last 24 hours
     ```
     ```
     - parameter completion: EventManager.EventHandler.
     - returns: Void.
     */
    func startingSoon(_ completion: EventManager.EventHandler = nil) {
        guard let user = User.current() else {
            completion?(nil, "")
            return
        }
        
        let eventQuery = Event.safeQuery()
        eventQuery?.whereKey(Event.Properties.isEnabled, equalTo: true)
        eventQuery?.whereKey(Event.Properties.startAt, greaterThanOrEqualTo: Date())
        eventQuery?.limit = 1000

        if let in24hours = Date().adding(hours: 24) {
            eventQuery?.whereKey(Event.Properties.startAt, lessThanOrEqualTo: in24hours)
        }

        eventQuery?.order(byDescending: Event.Properties.startAt)
        
        let query = InterestedEvent.safeQuery()
        query?.whereKey(InterestedEvent.Properties.user, equalTo: user)
        query?.whereKey(InterestedEvent.Properties.event, matchesQuery: eventQuery!)
        query?.limit = 1000

        query?.getFirstObjectInBackground(block: { (object, error) in
            if let err = error {
                completion?(nil, err.localizedDescription)
                return
            }
            
            guard let interestedEvent = object as? InterestedEvent else {
                completion?(nil, "".localized)
                return
            }
            
            completion?(interestedEvent.event, nil)
        })
        
    }
}

// MARK: - Methods dealing with events interested by an user
extension InterestedEventManager {
    
    /**
     Get last event user interested
     ```
     ```
     - parameter user: user.
     - parameter completion: EventHandler
     - returns: void.
     */
    func lastEventInterested(by user: User, _ completion: EventManager.EventHandler = nil) {
        
        let query = InterestedEvent.safeQuery()
        
        query?.limit = 1000
        query?.whereKey(InterestedEvent.Properties.isEnabled, equalTo: true)
        query?.whereKey(InterestedEvent.Properties.user, equalTo: user)
        query?.order(byDescending: InterestedEvent.Properties.createdAt)

        query?.getFirstObjectInBackground(block: { (object, error) in
            let interestedEvent = object as? InterestedEvent
            completion?(interestedEvent?.event, error?.localizedDescription)
        })
    }
    
    /**
     Get all events by an user
     ```
     ```
     - parameter event: Object Event.
     - parameter completion: InterestedEventHandler
     - returns: void.
     */
    func allEventsInterested(by user: User, _ completion: EventManager.ListEventsHandler = nil) {
        let query = InterestedEvent.query()
        query?.limit = 1000
        query?.includeKey(InterestedEvent.Properties.event)
        query?.includeKey(InterestedEvent.Properties.user)
        query?.includeKey("\(InterestedEvent.Properties.event).\(Event.Properties.owner)")
//        query?.addDescendingOrder(Event.Properties.startAt)
        query?.whereKey(InterestedEvent.Properties.isEnabled, equalTo: true)
        query?.whereKey(InterestedEvent.Properties.user, equalTo: user)
        query?.findObjectsInBackground(block: { (objects, error) in
            if let err = error {
                completion?([], err.localizedDescription)
                return
            }
            
            guard let interestedEvents = objects as? [InterestedEvent] else {
                completion?([], "".localized)
                return
            }
            
            completion?(interestedEvents.compactMap { $0.event }, nil)
        })
    }
    
    /**
     Count number of events interested by an user
     ```
     ```
     - parameter user: User.
     - parameter completion: ListEventsCountHandler
     - returns: void.
     */
    func countEventsInterested(by user: User, _ completion: EventManager.ListEventsCountHandler = nil) {
        let query = InterestedEvent.query()
        query?.includeKey(InterestedEvent.Properties.event)
        query?.includeKey(InterestedEvent.Properties.user)
        query?.includeKey("\(InterestedEvent.Properties.event).\(Event.Properties.owner)")
        
        query?.whereKey(InterestedEvent.Properties.isEnabled, equalTo: true)
        query?.whereKey(InterestedEvent.Properties.user, equalTo: user)
        query?.limit = 1000

        query?.countObjectsInBackground(block: { (nbEvents, error) in
            completion?(nbEvents, error?.localizedDescription)
        })
    }
}
