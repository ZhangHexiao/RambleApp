//
//  ReportEventManager.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-05.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

class ReportEventManager {

    typealias ReportedEventHandler = ((_ reportedEvent: ReportedEvent?, _ error: String?) -> Void)?
    
    /**
     Report an event into parse if user hasn't reported yet
     ```
     One user can report an event only once.
     System to hide an event after x flags. If the event is hidden: - the creator can see it (see the screen)
     Other users get a message “This event has been deactivated due to inappropriate content.”
     ```
     - parameter event: Object Event.
     - parameter completion: Return error if any
     - returns: void.
     */
    func createReport(event: Event, _ completion: ReportedEventHandler = nil) {
        
        hasEventBeenReported(event: event) { (reportedEvent, error) in
            if let err = error {
                completion?(nil, err.localized)
                return
            }
            
            if reportedEvent != nil {
                completion?(nil, RMBError.reportedEventTooManyTimes.localizedDescription)
            } else {
                let report = ReportedEvent()
                report.event = event
                report.user = User.current()
                report.isEnabled = true
                
                report.saveInBackground { (_, error) in
                    completion?(report, error?.localizedDescription)
                }
            }
        }
        
    }
    
    /**
     Check if an event has been reported by the current user
     ```
     ```
     - parameter event: Object Event.
     - returns: Promise<Bool>.
     */
    func hasEventBeenReported(event: Event, _ completion: ReportedEventHandler = nil) {
        
        guard let user = User.current() else {
            return
        }
        
        let query = ReportedEvent.query()
        query?.whereKey(InterestedEvent.Properties.isEnabled, equalTo: true)
        query?.whereKey(InterestedEvent.Properties.user, equalTo: user)
        query?.whereKey(InterestedEvent.Properties.event, equalTo: event)
        query?.limit = 1000
        query?.getFirstObjectInBackground(block: { (object, _) in
            completion?(object as? ReportedEvent, nil)
        })
    }
}
