//
//  NewEventMenuType.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-02.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

enum NewEventMenuType: Int {
    case eventName
    case category
    case startDate
    case endDate
    case location
    case description
    case isBookedRequired
    case nbAvailableTickets
    case indicativePrice
    case webLink
    
    func localized() -> String {
        switch self {
        case .eventName: return "Event name".localized
        case .category: return "Category".localized
        case .startDate: return "Start date".localized
        case .endDate: return "End date".localized
        case .location: return "Location".localized
        case .description: return "Description".localized
        case .isBookedRequired: return "Booking required".localized
            
        case .nbAvailableTickets: return "Number of available tickets (optional)".localized
        case .indicativePrice: return "Indicative price for tickets (optional)".localized
        case .webLink: return "Web link".localized
        }
    }
    
    static var kNumberOfItems: Int { return 11 }
}
