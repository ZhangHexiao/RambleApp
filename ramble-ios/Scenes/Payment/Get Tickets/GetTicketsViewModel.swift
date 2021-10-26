//
//  GetTicketsViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-10.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

typealias GetTicketsViewModelDelegate = Failable & Successable & Loadable

class GetTicketsViewModel {
    
    weak var delegate: GetTicketsViewModelDelegate?
    var event: Event
    var tickets: [TicketViewModel] = []
    
    var buttonTitle: String {
        let title = "Go to payment".localized
        return "\(title) - \(CurrencyHelper.format(value: totalPayment()))"
    }
    
    var paymentViewModel: PaymentViewModel {
        return PaymentViewModel(event: event, tickets: allSelectedTickets())
    }
    
    init(event: Event) {
        self.event = event
    }
    
    func loadData() {
        TicketManager().all(for: event) { [weak self] (tickets, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: true)
                return
            }
            self?.tickets = tickets.map { TicketViewModel(ticket: $0) }
            self?.delegate?.didLoadData()
        }
    }
    
    func hasAmountToPayment() -> Bool {
        return totalPayment() > 0
    }
    
    func hasSelectedMinimumQuantity() -> Bool {
        return !allSelectedTickets().isEmpty
    }
    
    func allSelectedTickets() -> [TicketViewModel] {
        return tickets.filter { $0.numberTicketSelected > 0 }
    }
    
    private func totalPayment() -> Int {
        var total = 0
        for ticket in tickets {
            total += ticket.numberTicketSelected * ticket.unitPrice
        }
        return total
    }
}

extension GetTicketsViewModel {
    func numberOfRows(at section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return tickets.count
        default: return 0
        }
    }
    
    func ticketViewModel(at indexPath: IndexPath) -> TicketViewModel {
        return tickets[indexPath.row]
    }
    
    func update(viewModel: TicketViewModel, at indexPath: IndexPath) {
        tickets[indexPath.row] = viewModel
        delegate?.didLoadData()
    }
}
