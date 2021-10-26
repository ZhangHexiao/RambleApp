//
//  CategoryType.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-02.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

enum CategoryType: Int, CaseIterable {
    case arts
    case charity
    case comedy
    case corporate
    case culture
    case dance
    case festivals
    case food
    case music
    case nightlife
    case sports
    case shopping
    case other
    //new
    case family
    case healthWellness
    case fashion
    
    func icon() -> UIImage {
        switch self {
        case .arts: return #imageLiteral(resourceName: "ic_arts")
        case .charity: return #imageLiteral(resourceName: "ic_charity")
        case .comedy: return #imageLiteral(resourceName: "ic_comedy")
        case .corporate: return #imageLiteral(resourceName: "ic_corporate")
        case .culture: return #imageLiteral(resourceName: "ic_culture")
        case .dance: return #imageLiteral(resourceName: "ic_dance")
        case .festivals: return #imageLiteral(resourceName: "ic_festival")
        case .food: return #imageLiteral(resourceName: "ic_food")
        case .music: return #imageLiteral(resourceName: "ic_music")
        case .nightlife: return #imageLiteral(resourceName: "ic_nightlife")
        case .sports: return #imageLiteral(resourceName: "ic_sports")
        case .shopping: return #imageLiteral(resourceName: "ic_shopping")
        case .other: return #imageLiteral(resourceName: "ic_other")
        // TODO: change new images
        case .family:  return #imageLiteral(resourceName: "family")
        case .healthWellness:  return #imageLiteral(resourceName: "health")
        case .fashion:  return #imageLiteral(resourceName: "fashion")
        }
    }
    
    func localized() -> String {
        switch self {
        case .arts: return "Arts".localized
        case .charity: return "Charity".localized
        case .comedy: return "Comedy".localized
        case .corporate: return "Corporate".localized
        case .culture: return "Culture".localized
        case .dance: return "Dance".localized
        case .festivals: return "Festivals".localized
        case .food: return "Food".localized
        case .music: return "Music".localized
        case .nightlife: return "Nightlife".localized
        case .sports: return "Sports".localized
        case .shopping: return "Shopping".localized
        case .other: return "Other".localized
        case .family: return "Family".localized
        case .healthWellness: return "Health & Wellness".localized
        case .fashion: return "Fashion".localized
        }
    }
    
    func rawString() -> String {
        switch self {
        case .arts: return "arts"
        case .charity: return "charity"
        case .comedy: return "comedy"
        case .corporate: return "corporate"
        case .culture: return "culture"
        case .dance: return "dance"
        case .festivals: return "festivals"
        case .food: return "food"
        case .music: return "music"
        case .nightlife: return "nightlife"
        case .sports: return "sports"
        case .shopping: return "shopping"
        case .other: return "other"
        case .family: return "family"
        case .healthWellness: return "health_wellness"
        case .fashion: return "fashion"
        }
    }
    
    static func getCategoryType(by name: String) -> CategoryType {
        switch name {
        case "arts": return .arts
        case "charity": return .charity
        case "comedy": return .comedy
        case "corporate": return .corporate
        case "culture": return .culture
        case "dance": return .dance
        case "festivals": return .festivals
        case "food": return .food
        case "music": return .music
        case "nightlife": return .nightlife
        case "sports": return .sports
        case "shopping": return .shopping
        case "other": return .other
        case "family": return .family
        case "health_wellness": return .healthWellness
        case "fashion": return .fashion
        default: return .other
        }
    }
    
    static var kNumberOfItems: Int {
        return 16
    }
    
    static var all: [CategoryType] {
        var sortedWithoutOther = CategoryType.allCases.filter{$0 != .other}.sorted {$0.localized() < $1.localized()}
        sortedWithoutOther.append(.other)
        return sortedWithoutOther
    }
}
