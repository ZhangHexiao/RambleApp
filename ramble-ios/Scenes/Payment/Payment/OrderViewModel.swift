//
//  OrderViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc.
//

import Foundation

class OrderViewModel {
    
    var tickets: [TicketViewModel] = []
    
    var total: Int = 0
    var serviceFee: Int = 0
    var subTotal: Int = 0
    var taxes: Int = 0
    
    init(tickets: [TicketViewModel]) {
        self.tickets = tickets
        calculateServiceFee()
        calculateSubTotal()

    }
    
    var serviceFeeFormatted: String {
        return CurrencyHelper.format(value: serviceFee)
      }
    
    var subtotalFormatted: String {
        return CurrencyHelper.format(value: subTotal)
    }
    
    var taxesFormatted: String {
        return CurrencyHelper.format(value: taxes)
    }
    
    var totalFormatted: String {
        return CurrencyHelper.format(value: subTotal + taxes)
    }
}

extension OrderViewModel {
    private func calculateSubTotal() {
        subTotal = 0
        for ticket in tickets {
            subTotal += ticket.numberTicketSelected * CurrencyHelper.finalUnitPrice(value: ticket.unitPrice)
            subTotal = subTotal + serviceFee
        }
    }
    private func calculateServiceFee() {
        serviceFee = 0
        for ticket in tickets {
            serviceFee += ticket.numberTicketSelected * CurrencyHelper.finalServiceFee(value: ticket.unitPrice)
        }
    }
}
