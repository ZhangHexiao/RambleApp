//
//  TicketBoughtViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-15.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

class TicketBoughtViewModel {
    
    var ticketBought: TicketBought
    
    var code: String {
        return ticketBought.objectId ?? ""
    }
    
    var name: String {
        return ticketBought.ticket?.name ?? ""
    }
    
    var price: String {
        
        let unitPrice = ticketBought.ticket?.unitPrice ?? 0
        if unitPrice == 0 { return "Free".localized }
        
        let finalUnitPrice = CurrencyHelper.finalUnitPrice(value: unitPrice)
        return CurrencyHelper.format(value: finalUnitPrice)
    }
    
    var ticketNumber: Int?
    
    var ticketNumberFormatted: String {
        let strTicket = "Ticket".localized
        
        if let ticketNumber = ticketNumber {
            return strTicket + " \(ticketNumber)"
        } else {
            return strTicket
        }
    }
    
    init(ticketBought: TicketBought) {
        self.ticketBought = ticketBought
    }
}
