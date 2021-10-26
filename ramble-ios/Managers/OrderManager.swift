//
//  OrderManager.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-12.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

class OrderManager {
    
    typealias OrderHandler = ((_ order: Order?, _ error: String?) -> Void)?
    typealias TaxesHandler = ((_ taxes: Int, _ error: String?) -> Void)?
    typealias TicketsBoughtHandler = ((_ ticketBoughtList: [TicketBought], _ error: String?) -> Void)?

    /**
     Action buy tickets.
     ```
      Using promise kit to make the payment.
      1 - Call server function to pay using Stripe
      5 - Fetch order order.
      6 - Get tickets bought from this order
     ```
     - parameter cardToken: Card token from stripe
     - parameter items: List of TicketViewModel
     - parameter from event: Event model
     - parameter completion: TicketsBoughtHandler block
     - returns: void
     */
    func buyTickets(cardToken: String?, items: [TicketViewModel], from event: Event, _ completion: TicketsBoughtHandler = nil) {
        
        firstly {
            self.pay(cardToken: cardToken, items: items, from: event)
        }.then { order in
            self.fetchInBackground(order: order)
        }.then { order in
            TicketBoughtManager().getMyTickets(for: order)
        }.done { ticketsBought in
            InterestedEventManager().removeInterestedEvent(event: event)
            completion?(ticketsBought, nil)
        }.catch { error in
            completion?([], error.localizedDescription)
        }
    }
    
    /**
     Calculate taxes
     - parameter subTotal: Int
     - parameter completion: TaxesHandler block
     - returns: void
     */
    func calculateTaxes(subTotal: Int, _ completion: TaxesHandler = nil) {
        var params: [AnyHashable: Any] = [:]
        params["subtotal"] = subTotal
       
        PFCloud.callFunction(inBackground: "taxAmount", withParameters: params) { (result, error) in
            print(error?.localizedDescription ?? "taxAmount")
            
            if let err = error {
                completion?(0, err.localizedDescription)
                return
            }
            
            guard let tax = result as? Int else {
                completion?(0, RMBError.couldntGetTaxes.localizedDescription)
                return
            }
            
            completion?(tax, error?.localizedDescription)
        }
    }
    
    /**
     Create Order in Database
     ```
     ```
     - parameter event: Event to create an order
     - returns: Promise Order
     */
    private func createOrder(event: Event) -> Promise<Order> {
        return Promise { seal in
            let order = Order()
            order.isEnabled = true
            order.event = event
            order.orderStatus = OrderStatus.pending.rawValue
            order.user = User.current()
            
            order.saveInBackground(block: { (_, error) in
                if let err = error {
                    seal.reject(err)
                } else {
                    seal.fulfill(order)
                }
            })
        }
    }
    
    /**
     Fetch Order
     - parameter order: Order
     - returns: Promise Order
     */
    private func fetchInBackground(order: Order) -> Promise<Order> {
        return Promise { seal in
            order.fetchInBackground(block: { (_, error) in
                if let err = error {
                    seal.reject(err)
                } else {
                    seal.fulfill(order)
                }
            })
        }
    }

    /**
     - parameter items: List of TicketViewModel
     - parameter from event: Event model
     - parameter completion: OrderHandler block
     - returns: void
     */
    
///********Pay tickets**********
    func pay(cardToken: String?, items: [TicketViewModel], from event: Event) -> Promise<Order> {
        var params: [AnyHashable: Any] = [:]
        params["stpCustmerId"] = User.current()?.stpCustomerId ?? ""
        params["paymentMethodId"] = User.current()?.stpPaymentMethodId ?? ""
        params["cardToken"] = cardToken ?? ""
        params["eventId"] = event.objectId ?? ""
        params["creatorStpAccountId"] = event.creatorStpAccountId ?? ""
        
        var ticketsArray: [[String: Any]] = []
        
        for item in items {
            var ticketsParams: [String: Any] = [:]
            ticketsParams["ticket"] = item.ticket.objectId ?? ""
            ticketsParams["quantity"] = item.numberTicketSelected
            ticketsArray.append(ticketsParams)
        }
        
        params["purchaseData"] = ticketsArray
        
        return Promise { seal in
            PFCloud.callFunction(inBackground: "buyTickets", withParameters: params) { (result, error) in
                if let err = error {
                    seal.reject(err)
                    return
                }
                guard let order = result as? Order else {
                    seal.reject(RMBError.couldntBuyTickets)
                    return
                }
                seal.fulfill(order)
            }
        }
    }
///********End of pay tickets****************
}

// MARK: - Methods dealing with events user has bought
extension OrderManager {
    
    /**
     Get last event user bought
     ```
     ```
     - parameter user: user.
     - parameter completion: EventHandler
     - returns: void.
     */
    func lastEventBought(by user: User, _ completion: EventManager.EventHandler = nil) {
        let query = Order.safeQuery()
        query?.whereKey(Order.Properties.user, equalTo: user)
        query?.order(byDescending: Order.Properties.createdAt)
        query?.limit = 1000
        query?.getFirstObjectInBackground(block: { (object, error) in
            let order = object as? Order
            completion?(order?.event, error?.localizedDescription)
        })
    }
    
    func lastEventBoughtIn24h(by user: User, _ completion: EventManager.EventHandler = nil) {
        let query = Order.safeQuery()
        query?.limit = 1000
        query?.whereKey(Order.Properties.user, equalTo: user)
        query?.order(byDescending: Order.Properties.createdAt)
        
        query?.getFirstObjectInBackground(block: { (object, error) in
            if let error = error {
                completion?(nil, error.localizedDescription)
            } else {
                guard let order = object as? Order else {
                    completion?(nil, RMBError.unknown.localizedDescription)
                    return
                }
                
                guard let eventStatus = order.event?.eventStatus, let startAt = order.event?.startAt else {
                    completion?(nil, RMBError.unknown.localizedDescription)
                    return
                }
                
                if (startAt.offset(from: Date())) && eventStatus == EventStatus.active.rawValue {
                    completion?(order.event, error?.localizedDescription)
                } else {
                    completion?(nil, error?.localizedDescription)
                }
            }
        })
    }
    
    /**
     Get all events bought by an user
     ```
     ```
     - parameter event: Object Event.
     - parameter completion: InterestedEventHandler
     - returns: void.
     */
    func allEventsBought(by user: User, _ completion: EventManager.ListEventsHandler = nil) {
        let query = Order.safeQuery()
        query?.limit = 1000
        query?.whereKey(Order.Properties.user, equalTo: user)
        query?.order(byDescending: Event.Properties.startAt)
        query?.findObjectsInBackground(block: { (objects, error) in
            if let err = error {
                completion?([], err.localizedDescription)
                return
            }
            
            guard let orders = objects as? [Order] else {
                completion?([], "".localized)
                return
            }
            
            var events = orders.compactMap { $0.event }
            events = events.filterDuplicates { $0.objectId == $1.objectId }
            completion?(events, nil)
        })
    }
    
    /**
     Count number of events bought by an user
     ```
     ```
     - parameter user: User.
     - parameter completion: ListEventsCountHandler
     - returns: void.
     */
    func countEventsBought(by user: User, _ completion: EventManager.ListEventsCountHandler = nil) {
        let query = Order.safeQuery()
        query?.whereKey(Order.Properties.user, equalTo: user)
        query?.countObjectsInBackground(block: { (nbOrders, error) in
            completion?(nbOrders, error?.localizedDescription)
        })
    }
}
