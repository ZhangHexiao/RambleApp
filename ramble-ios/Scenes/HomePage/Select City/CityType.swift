//
//  CityType.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2019-12-28.
//  Copyright © 2019 Ramble Technologies Inc. All rights reserved.
//

import Foundation
enum CityType: Int, CaseIterable {
    case Montreal
    case Toronto
    case Vancouver
//    case Other

    
//    func icon() -> UIImage {
//        switch self {
//        case .Montreal: return #imageLiteral(resourceName: "ic_arts")
//        case .Toronto: return #imageLiteral(resourceName: "ic_arts")
//        case .Vancouver: return #imageLiteral(resourceName: "ic_charity")
//        }
//    }
    
    func localized() -> String {
        switch self {
        case .Montreal: return "Montreal"
        case .Toronto: return "Toronto"
        case .Vancouver: return "Vancouver"
        }
    }
    
    func location() -> String {
        switch self {
        case .Montreal: return "Quebec, Canada"
        case .Toronto: return "Ontario, Canada"
        case .Vancouver: return "British Columbia, Canada"
        }
    }
    
    func rawString() -> String {
        switch self {
        case .Montreal: return "Montreal"
        case .Toronto: return "Toronto"
        case .Vancouver: return "Vancouver"
        }
    }
    
    func coordinate() -> (latitude:Double,longitude:Double) {
        switch self {
        case .Montreal: return (latitude: 45.508888, longitude: -73.561668)
        case .Toronto: return (latitude: 43.651070, longitude: -79.347015)
        case .Vancouver: return (latitude: 49.2827, longitude: -123.1207)
        }
    }
       
    static func getCityType(by name: String) -> CityType {
        switch name {
        case "Montreal": return .Montreal
        case "Toronto": return .Toronto
        case "Vancouver": return .Vancouver
        default:
        return .Montreal
        }
    }
    
    static var kNumberOfItems: Int {
        return 16
    }
    
    static var all: [CityType] {
        let sortedWithoutOther = CityType.allCases.sorted {$0.localized() < $1.localized()}
//        sortedWithoutOther.append(.other)
        return sortedWithoutOther
    }
}
