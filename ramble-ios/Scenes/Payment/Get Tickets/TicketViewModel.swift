//
//  TicketViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-10.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

class TicketViewModel {
    
    var ticket: Ticket
    var numberAvailableTickets: Int
    var numberTicketSelected: Int = 0
    
    var startAt: Date? {
        return ticket.startAt
    }
    
    var endAt: Date? {
        return ticket.endAt
    }
    
    var event: Event? {
        return ticket.event
    }
    
    var name: String {
        return ticket.name ?? ""
    }
    
    var ticketsLeft: String {
        if hasSoldout {
            return "Sold out".localized
        }
        
        let ticketsLeft = "tickets left".localized
        return "\(numberAvailableTickets) \(ticketsLeft)"
    }
    
    var formattedPrice: String {
        if unitPrice == 0 { return "Free".localized }
        
        return CurrencyHelper.format(value: unitPrice)
    }
    
    var unitPrice: Int {
        return ticket.unitPrice
    }
    
    var orderPrice: String {
        return CurrencyHelper.format(value: CurrencyHelper.finalUnitPrice(value: unitPrice) * numberTicketSelected)
    }
    
    var quantity: String {
        return "\(numberTicketSelected)"
    }
    
    var description: String {
        return ticket.desc ?? ""
    }
    
    var hasSoldout: Bool {
        if numberTicketSelected > 0 { return false } // It means user has selected at least one ticket
        
        return numberAvailableTickets <= 0
    }
    
    init(ticket: Ticket) {
        self.ticket = ticket
        self.numberAvailableTickets = (ticket.availableTickets - ticket.ticketsSold)
    }
    
    func add() {
        if hasSoldout { return }
        
        if numberAvailableTickets > 0 {
            numberTicketSelected += 1
            numberAvailableTickets -= 1
        }
    }
    
    func remove() {
        if hasSoldout { return }
        
        if numberTicketSelected > 0 {
            numberTicketSelected -= 1
            numberAvailableTickets += 1
        }
    }
}
