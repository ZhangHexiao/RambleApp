//
//  CurrencyHelper.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-10.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

struct CurrencyHelper {
    
    // Stripe fees: 2,9%+0,30$(on Ramble, will not charge user and creator)
    // Ramble fee: 15%, charge creator
    // Service fee: 5% charge user
    // So, if the organizer sells at 100$, he will only receive 100*85%
    // Total charge: 100*1.05*14.95% + 100 *5% +100 on server
    // Application fee on server: 100*1.05*14.95% + 100 *5% +100*15%
    
    static let taxes: Double = 0.14975
    static let rambleFee: Double = 0.15
    static let serviceFeePercent: Double = 0.05
    static let stripeFeePercent: Double = 0.029
    static let stripeFeeUnit: Double = 0.3
    
    static func format(value: Int) -> String {
        return String(format: "$ %.02f", (Float(value) / 100))
    }
    
    static func finalUnitPrice(value: Int) -> Int {
        if value == 0 { return 0 }
        
        let valueDouble = Double(value) / 100
        let result = valueDouble
        return Int(result * 100)
    }
    
    static func finalServiceFee(value: Int) -> Int {
        if value == 0 { return 0 }
        
        let valueDouble = Double(value) / 100
        let result =  valueDouble * serviceFeePercent
        return Int(result * 100)
    }
    
    
}
