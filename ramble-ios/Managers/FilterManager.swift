//
//  FilterManager.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-24.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

class FilterManager {
    
    func loadFilterHome() -> (fromDate: Date?, toDate: Date?, categories: [String]?) {
        
        let defaults = UserDefaults.standard
        
        let fromDate = defaults.object(forKey: Const.NSUserDefaultsKey.fromDateForHome) as? Date
        let toDate = defaults.object(forKey: Const.NSUserDefaultsKey.toDateForHome) as? Date
        
        var listCategoriesSelected: [String]?
        
        if let categoryListInt: [Int] = defaults.object(forKey: Const.NSUserDefaultsKey.categoriesForHome) as? [Int] {
            listCategoriesSelected = categoryListInt.map({ return CategoryType(rawValue: $0) })
                .compactMap { $0 }
                .map { $0.rawString() }
        }
        
        return (fromDate: fromDate, toDate: toDate, categories: listCategoriesSelected)
        
    }
    func loadFilterSearch() -> (fromDate: Date?, toDate: Date?, categories: [String]?) {
        
        let defaults = UserDefaults.standard
        
        let fromDate = defaults.object(forKey: Const.NSUserDefaultsKey.fromDateForSearch) as? Date
        let toDate = defaults.object(forKey: Const.NSUserDefaultsKey.toDateForSearch) as? Date
        
        var listCategoriesSelected: [String]?
        
        if let categoryListInt: [Int] = defaults.object(forKey: Const.NSUserDefaultsKey.categoriesForSearch) as? [Int] {
            listCategoriesSelected = categoryListInt.map({ return CategoryType(rawValue: $0) })
                .compactMap { $0 }
                .map { $0.rawString() }
        }
        
        return (fromDate: fromDate, toDate: toDate, categories: listCategoriesSelected)
        
    }
}
