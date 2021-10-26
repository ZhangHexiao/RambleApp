//
//  TicketBoughtManager.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-12.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

class TicketBoughtManager {
    
    /**
     Retrieve all tickets that user bought
     - parameter event: Event
     - returns: Promise of TicketBought array.
     */
    func getMyTickets(for event: Event) -> Promise<[TicketBought]> {
        return Promise { seal in
            
            guard let user = User.current() else {
                seal.reject(RMBError.expiredSession)
                return
            }
            
            let query = TicketBought.query()
            query?.limit = 1000
            query?.whereKey(TicketBought.Properties.isEnabled, equalTo: true)
            query?.whereKey(TicketBought.Properties.event, equalTo: event)
            query?.whereKey(TicketBought.Properties.user, equalTo: user)
            query?.includeKeys([TicketBought.Properties.event, TicketBought.Properties.user, TicketBought.Properties.ticket])
            
            query?.findObjectsInBackground(block: { (objects, _) in
                seal.fulfill(objects as? [TicketBought] ?? [])
            })
        }
    }
    
    /**
     Retrieve all tickets given an order
     - parameter order: Order
     - returns: Promise of TicketBought array.
     */
    func getMyTickets(for order: Order) -> Promise<[TicketBought]> {
        return Promise { seal in
            
            guard let user = User.current() else {
                seal.reject(RMBError.expiredSession)
                return
            }
            
            let query = TicketBought.query()
            query?.limit = 1000
            query?.whereKey(TicketBought.Properties.isEnabled, equalTo: true)
            query?.whereKey(TicketBought.Properties.order, equalTo: order)
            query?.whereKey(TicketBought.Properties.user, equalTo: user)
            query?.includeKeys([TicketBought.Properties.event,
                                TicketBought.Properties.user,
                                "\(TicketBought.Properties.event).\(Event.Properties.owner)",
                                TicketBought.Properties.ticket])

            query?.findObjectsInBackground(block: { (objects, _) in
                seal.fulfill(objects as? [TicketBought] ?? [])
            })
        }
    }
}
