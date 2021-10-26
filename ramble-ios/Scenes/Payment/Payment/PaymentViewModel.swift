//
//  PaymentViewModel.swift
//  ramble-ios
//
//  Created by HexiaoZhang Ramble Technologies Inc. on 2018-10-10.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Stripe

protocol PaymentViewModelDelegate: Failable, Successable, Loadable,EmptyCardCauseFail {
    func didBuySuccess(ticketsBoughtViewModel: TicketsBoughtViewModel)
}

class PaymentViewModel {
    
    weak var delegate: PaymentViewModelDelegate?
    
    var event: Event
    var tickets: [TicketViewModel]
    var totalTickets: Int = 0
    var cards: [STPPaymentMethodCard] = []
    
    var hasCreditCard: Bool {
        return !cards.isEmpty
    }
    
    var buttonTitle: String {
        if tickets.first?.numberTicketSelected ?? 0 > 0 {
            return String(format: "Buy ticket(s)".localized, String(totalTickets))
        }
        return "Please select number of guest(s)"
    }
    
    var creditCard: String {
        if hasCreditCard {
            return "Credit Card".localized + " " + (cards.first?.last4 ?? "")
        } else {
            return "No credit card".localized
        }
    }
    
    var creditCardActionTitle: String {
        if hasCreditCard {
            return "Change".localized
        } else {
            return "Add".localized
        }
    }
    
    var orderViewModel: OrderViewModel
    
    init(event: Event, tickets: [TicketViewModel]) {
        self.event = event
        self.tickets = tickets
        orderViewModel = OrderViewModel(tickets: tickets)
        totalTickets = calculateTotalTickets()
    }
    
    func fetch() {
        StripeService().fetchCardsList { [weak self] (cards, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: false)
                return
            }
            self?.cards = cards ?? []
            self?.delegate?.didLoadData()
        }
        
        OrderManager().calculateTaxes(subTotal: orderViewModel.subTotal) { [weak self] (taxes, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: false)
                return
            }
            self?.orderViewModel.taxes = taxes
            self?.delegate?.didLoadData()
        }
    }
    
    func buyTickets() {
//        if total price is 0. tickets are Free. We don't need the credit card
        if calculateTotalPrice() > 0 {
            if cards.isEmpty {
                //===Not pop up error======
                //  delegate?.didFail(error:   RMBError.emptyCreditCard.localizedDescription, removeFromTop: false)
                //=if the credit card is void, then jump to add credit card=========
                self.delegate?.emptyCardFail()
                return
            }
        }
        let userPaymentId = User.current()?.stpPaymentMethodId
        OrderManager().buyTickets(cardToken: userPaymentId, items: tickets, from: event) { [weak self] (ticketsBought, error) in
            
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: false)
                return
            }
            
            guard let event = self?.event else {
                return
            }
            
            self?.delegate?.didBuySuccess(ticketsBoughtViewModel: TicketsBoughtViewModel(event: event, ticketsBought: ticketsBought))
        }
        
    }
    
    private func prepareToShowTicketsBought(_ ticketsBought: [TicketBought]) {
        let viewModel = TicketsBoughtViewModel(event: event, ticketsBought: ticketsBought)
        delegate?.didBuySuccess(ticketsBoughtViewModel: viewModel)
    }
    
}

extension PaymentViewModel {
    
    func sendButtonTheme() -> ButtonTheme {
        if tickets.first?.numberTicketSelected ?? 0 > 0 {
            return .green
        }
        return .disabled
    }
    
    private func calculateTotalTickets() -> Int {
        return tickets.reduce(0) { value, ticket in value + ticket.numberTicketSelected }
    }
    
    private func calculateTotalPrice() -> Int {
        return tickets.reduce(0) { value, ticket in value + ticket.unitPrice }
    }
}

extension PaymentViewModel {
    
    func setReviewReminder(){
        let viewModel = EventViewModel(event: self.event)
        if viewModel.hasBoughtTickets == true {
            let content = UNMutableNotificationContent()
            content.title = "Ramble"
            content.sound = .default
            content.body = "Now you can rate your last experience in Ramble!"
            content.badge = 1
            content.userInfo = ["event": self.event.objectId ?? "Undefined"]
            if let targetDate = (event.endAt?.addingTimeInterval(60*60*2))
            {
                // Set the test time as 10s after buying tickets
                //          let targetDate = (Date().addingTimeInterval(10))
                let triger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                let request = UNNotificationRequest(identifier: "reviewReminder", content: content, trigger: triger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil{
                        print("something wrongt")
                        return
                    }
                })
            }
            return
        }//end of if boughtTickets
    }//end of set reminder
}
