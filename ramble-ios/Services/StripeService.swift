//
//  StripeService.swift
//  ramble-ios
//
//  Created by Hexiao Zhang. on 2018-10-10.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Stripe
import Parse
import PromiseKit

class StripeService {
    
    typealias ListCardsHandler = ((_ cards: [STPPaymentMethodCard]?, _ error: String?) -> Void)?
    typealias StripeResultBlock = (Any?, Error?) -> Void

    private var stripeAPIClient: STPAPIClient = STPAPIClient.shared()
    
    func createUserAccount(completion: @escaping CloudCallback) {
        let userName = (User.current()?.name ?? " ") + " " + (User.current()?.lastName ?? " ")
        call(function: .createUserAccount(params: ["userName": userName])) { (result, error) in

            print(error?.localizedDescription ?? "error is nil")
            
            guard error == nil, let result = result as? [AnyHashable: Any], let id = result["customerId"] as? String else {
                completion(false, error)
                return
            }
            User.current()?.stpCustomerId = id
            User.current()?.saveInBackground(block: { (_, error) in
                if error != nil {
                    completion(false, error)
                }
            })
        }
    }
///create account by payment method see below
    func fetchCardsList(completion: ListCardsHandler = nil) {
        
        call(function: .fetchCardsList) { (result, error) in
            guard error == nil else {
                completion?(nil, error?.localizedDescription)
                return
            }
            
            var cards: [STPPaymentMethodCard] = []
         
            if let result = result as? [AnyHashable: Any], let cardsData = result["data"] as? [[AnyHashable: Any]] {
                for cardData in cardsData {
                    let cardDetail = cardData["card"]
                    if let card = STPPaymentMethodCard.decodedObject(fromAPIResponse: cardDetail as? [AnyHashable : Any]) {
                        cards.append(card)
                    }
                }
            }
            completion?(cards, nil)
        }
    }
    
    func addCard(number: String, cvc: String, dateString: String, name: String, completion: @escaping CloudCallback) {
/// if use card  then choose STPCardParams, if use paymen the choose STPPaymentMethodCardParams
/// This is for create token
//      let params = STPCardParams()
        let params = STPPaymentMethodCardParams()
        params.number = number
        params.cvc = cvc
//        params.name = names
        let dateParams = dateString.components(separatedBy: "/")
        if dateParams.count == 2
        {
                params.expMonth = NSNumber(value: Int(dateParams.first!) ?? 0)
                params.expYear = NSNumber(value: Int(dateParams[1])!)
        } else {
           params.expMonth = 0
           params.expYear = 0
        }
///**change createToken to create Payment Method and save ID with customer Account**
//        stripeAPIClient.createToken(withCard: params) { (token, error) in
//            guard error == nil, let token = token else {
//                completion(false, error)
//                return
//            }
//            if let id = User.current()?.stpCustomerId, id != "" {
//                self.call(function: .addCard(params: ["stripeToken": token.tokenId, "customerId": id]), completion: { (_, error) in
//                    completion(error == nil, error)
//                })
//            } else {
//                self.createAccount(token: token, completion: completion)
//            }
//        }
///**End of creating card token*****
            
///***Create new PaymentMehod***   
       let paymentMethodParams = STPPaymentMethodParams(card: params, billingDetails: nil, metadata: nil)
        stripeAPIClient.createPaymentMethod(with: paymentMethodParams){ (paymentMethod, error) in
            guard error == nil, let paymentMethod = paymentMethod else {
                completion(false, error)
                return
            }
            User.current()?.stpPaymentMethodId = paymentMethod.stripeId
            User.current()?.saveInBackground(block: completion)
            if  User.current()?.stpCustomerId == nil || User.current()?.stpCustomerId == ""{
                self.createUserAccount(completion: completion)
            }
            if let id = User.current()?.stpCustomerId, id != "" {
                self.call(function: .addPayment(params: ["paymentMethod": paymentMethod.stripeId, "customerId": id]), completion: { (_, error) in
                    completion(error == nil, error)
                })
            } else {
                completion(false, "can not create stripe account" as? Error)
            }//end of else
        }///******End of create new PaymentMehod*****
    }
    /// end of remove card from server side
    func removePayment(paymentMethodId: String?, completion: @escaping CloudCallback) {
        call(function: .removePayment(params: ["paymentMethod": paymentMethodId ?? ""])) { (_, error) in
            guard error == nil else {
                completion(false, error)
                return
            }
            User.current()?.stpPaymentMethodId = nil
            User.current()?.saveInBackground(block: { (_, error) in
                if error != nil {
                    completion(false, error)
                }else{
                    completion(true, nil)
                }
            })
        }
    }
    ///create account by payment method see below
    //    private func createAccount(paymentMethod: STPPaymentMethod, completion: @escaping CloudCallback) {
    //        call(function: .createAccount(params: ["paymentMethod": paymentMethod.stripeId])) { (result, error) in
    //
    //            print(error?.localizedDescription ?? "error is nil")
    //
    //            guard error == nil, let result = result as? [AnyHashable: Any], let id = result["customerId"] as? String else {
    //                completion(false, error)
    //                return
    //            }
    //            User.current()?.stpCustomerId = id
    //            User.current()?.saveInBackground(block: { (_, error) in
    //                if error != nil {
    //                    completion(false, error)
    //                }
    //            })
    //
    //        }
    //    }
    /// This the function to create the account from the server side, currently we not using it
    //    private func createAccount(token: STPToken, completion: @escaping CloudCallback) {
    //        call(function: .createAccount(params: ["stripeToken": token.tokenId])) { (result, error) in
    //            print("createAccount")
    //            print(error?.localizedDescription ?? "error is nil")
    //
    //            guard error == nil, let result = result as? [AnyHashable: Any], let id = result["customerId"] as? String else {
    //                completion(false, error)
    //                return
    //            }
    //            User.current()?.stpCustomerId = id
    //            User.current()?.saveInBackground(block: completion)
    //        }
    //    }
    /// This the function to create the payment method from the server side, currently we not using it
    //    private func createPaymentMethod(token: STPToken, completion: @escaping CloudCallback) {
    //
    //        call(function: .createPaymentMethod(params: ["stripeToken": token.tokenId])) { (result, error) in
    //            print("createPaymentMethod")
    //            print(error?.localizedDescription ?? "error is nil")
    //
    //            guard error == nil, let result = result as? [AnyHashable: Any], let id = result["paymentMethodId"] as? String else {
    //                completion(false, error)
    //                return
    //            }
    //            User.current()?.stpPaymentMethodId = id
    //            User.current()?.saveInBackground(block: completion)
    //        }
    //    }
    ///******End of create new PaymentMehod on server side*****
    /// This the function to remove card from server side
    //    func removeCard(card: STPPaymentMethodCard?, completion: @escaping CloudCallback) {
    //        call(function: .removeCard(params: ["customerId": User.current()?.stpCustomerId ?? "", "cardId": card?.brand ?? ""])) { (_, error) in
    //            guard error == nil else {
    //                completion(false, error)
    //                return
    //            }
    //            completion(true, nil)
    //        }
    //    }
}

extension StripeService {
    enum RMBCloudFunction {
//      case createAccount(params: [AnyHashable: Any])
//      case addCard(params: [AnyHashable: Any])
//      case removeCard(params: [AnyHashable: Any])
        ///creat PaymentMethod in the client side not on server
//      case createPaymentMethod(params: [AnyHashable: Any])
        case addPayment(params: [AnyHashable: Any])
        case removePayment(params: [AnyHashable: Any])
        case fetchCardsList
        case createUserAccount(params: [AnyHashable: Any])
        
        var name: String {
            switch self {
//          case .createAccount: return "stripe_" + "createAccount"
            case .createUserAccount: return "stripe_" + "createUserAccount"
//          case .addCard: return "stripe_" + "addCard"
//          case .removeCard: return "stripe_" + "removeCard"
            case .fetchCardsList: return "stripe_" + "paymentList"
//          case .createPaymentMethod: return "stripe_" +   "createPaymentMethod"
            case .addPayment: return "stripe_" + "addPayment"
            case .removePayment: return "stripe_" + "removePayment"
            }
        }
        
        var params: [AnyHashable: Any]? {
            switch self {
//          case .createAccount(let params): return params
            case .createUserAccount(let params): return params
//          case .addCard(let params): return params
//          case .removeCard(let params): return params
            case .fetchCardsList: return nil
//          case .createPaymentMethod(let params): return params
            case .addPayment(let params): return params
            case .removePayment(let params): return params
            }
        }
    }
    
    func call(function: RMBCloudFunction, completion: @escaping StripeResultBlock) {
        PFCloud.callFunction(inBackground: function.name, withParameters: function.params) { (result, error) in
            completion(result, error)
        }
    }
    
    typealias CloudCallback = (_ success: Bool, _ error: Error?) -> Void

}
