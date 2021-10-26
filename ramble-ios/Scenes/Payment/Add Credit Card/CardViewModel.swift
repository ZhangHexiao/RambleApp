//
//  CardViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-11.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Stripe

protocol CardViewModelDelegate: Failable, Successable {
    
}

class CardViewModel {
    
    typealias StringHandler = (String) -> Void

    weak var delegate: CardViewModelDelegate?
    
    var card: STPPaymentMethodCard?
    
    var numberChanged: StringHandler?
    var ccvChanged: StringHandler?
    var dateChanged: StringHandler?
    var cardHolderChanged: StringHandler?

    var hasCard: Bool {
        return card != nil
    }
    
    var number: String = "" {
        didSet {
            numberChanged?(number)
        }
    }
    
    var ccv: String = "" {
        didSet {
            ccvChanged?(ccv)
        }
    }
    
    var date: String = "" {
        didSet {
            dateChanged?(date)
        }
    }
    
    var cardHolder: String = "" {
        didSet {
            cardHolderChanged?(cardHolder)
        }
    }
    
    func inject(card: STPPaymentMethodCard?) {
        self.card = card
        
        number = "•••• •••• •••• " + (card?.last4 ?? "••••")
        ccv = "•••"
        if let month = card?.expMonth, let year = card?.expYear {
            date = String(format: "%02d/%02d", month, year)
        }
//        cardHolder = card?.name ?? ""
    }
    
    func save() {
        StripeService().addCard(number: number, cvc: ccv, dateString: date, name: cardHolder) { [weak self] (_, error) in
            if let err = error {
                self?.delegate?.didFail(error: err.localizedDescription, removeFromTop: false)
                return
            }
            self?.delegate?.didSuccess(msg: "Card created".localized, removeFromTop: true)
        }
    }
    
    func update() {
        self.save()
/// This part is for deleting the original credit card, but now we gonna save all the card in user account
//        let previousPaymentId = User.current()?.stpPaymentMethodId
//        StripeService().addCard(number: number, cvc: ccv, dateString: date, name: cardHolder) { [weak self] (_, error) in
//            if let err = error {
//                self?.delegate?.didFail(error: err.localizedDescription, removeFromTop: false)
//                return
//            }
//         StripeService().removePayment(paymentMethodId: previousPaymentId) { [weak self] (success, error) in
//            if let err = error {
//                self?.delegate?.didFail(error: err.localizedDescription, removeFromTop: false)
//                return
//            }
//            self?.delegate?.didSuccess(msg: "Card Changed".localized, removeFromTop: true)
//        }
//    }
}
}
extension CardViewModel {
    func shouldChangeCCV(currentCCV: String, in range: NSRange, with string: String) -> Bool {
        let potential = (currentCCV as NSString).replacingCharacters(in: range, with: string)
        if string == "" {
            ccv = potential
            return false
        }
        if Int(string) == nil { return false }
        
        if potential.count > 4 { return false }
        
        ccv = potential
        return false
    }
    
    func shouldChangeDate(currentDate: String, in range: NSRange, with string: String) -> Bool {
        if string == "" {
            // if deleting a slash, delete the preceding digit too
            if (currentDate as NSString).substring(with: range) == "/" && range.location > 1 {
                date = (currentDate as NSString).replacingCharacters(in: NSRange(location: range.location - 1, length: 2), with: "")
                return false
            }
            let potential = (currentDate as NSString).replacingCharacters(in: range, with: string)
            date = potential
            return false
        }
        
        if Int(string) == nil { return false } // only digits
        
        let potential = (currentDate as NSString).replacingCharacters(in: range, with: string)
        let numbers = potential.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if numbers.count > 4 { return false }
        
        if numbers.count == 1 && Int(numbers)! > 1 { return false }
        
        if numbers.count == 2 {
            if Int(numbers)! > 12 {
                let firstDigit = (numbers as NSString).substring(to: 1)
                let secondDigit = (numbers as NSString).substring(from: 1)
                date = "0" + firstDigit + "/" + secondDigit
                return false
            } else {
                date = numbers + "/"
                return false
            }
        }
        date = potential
        return false
    }
    
    func shouldChangeCardNumber(currentNumber: String, in range: NSRange, with string: String) -> Bool {
        
        if string == "" {
            // if deleting a space ((location + 1) % 5 == 0)
            if range.length == 1 && (range.location + 1) % 5 == 0 && range.location > 1 {
                // delete the previous digit
                
                number = (currentNumber as NSString).replacingCharacters(in: NSRange(location: range.location - 1, length: 2), with: "")
                return false
            }
        }
        
        let potential = (currentNumber as NSString).replacingCharacters(in: range, with: string)
        var numbers = potential.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() // only digits
        
        if numbers.count > 16 {
            return false
        }
        
        for iterator in 1..<4 {
            if numbers.count > (iterator * 4) + (iterator - 1) {
                numbers.insert(Character(" "), at: numbers.index(numbers.startIndex, offsetBy: (iterator * 4) + (iterator - 1)))
            } else {
                break
            }
        }
        
        number = numbers
        return false
    }
    
    func shouldChangeHolderName(currentHolderName: String, in range: NSRange, with string: String) -> Bool {
        cardHolder = currentHolderName
        return true
    }

}
