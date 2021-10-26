//
//  FilterViewModel.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-09-17.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol FilterViewModelDelegate: class {
    func didLoad()
}

class FilterViewModel {
    
    var fromDate: Date?
    var toDate: Date?
    
    var listCategoriesSelected: [CategoryType] = []
    var allCategories: [CategoryType] = CategoryType.all
    weak var delegate: FilterViewModelDelegate?
    
    init(pageType: String) {
        loadFilter(pageType:pageType)
        delegate?.didLoad()
    }
    
    func clearAll() {
        fromDate = nil
        toDate = nil
        listCategoriesSelected = []
        delegate?.didLoad()
    }
    
    func isCategorySelected(category: CategoryType) -> Bool {
        return listCategoriesSelected.contains(category)
    }
    
    func fromDateFormatted() -> String? {
        // If it's empty shows default value
        guard let date = fromDate else {
            return nil
        }
        // Starts today at 12:00 AM || Starts May 5 at 12:00 AM
        return "\(RMBDateFormat.dayMonth.combineDateAndHourWithAt(date: date, with: date, type: .hourMin))"
    }
    
    func toDateFormatted() -> String? {
        guard let date = toDate else {
            return nil
        }
        // Ends today at 12:00 AM || Ends May 5 at 12:00 AM
        return "\(RMBDateFormat.dayMonth.combineDateAndHourWithAt(date: date, with: date, type: .hourMin))"
    }
    
    func toggle(category: CategoryType) {
        if let index = listCategoriesSelected.index(of: category) {
            listCategoriesSelected.remove(at: index)
        } else {
            listCategoriesSelected.append(category)
        }
    }
    
    func save(pageType:String) {
        let defaults = UserDefaults.standard
        if pageType == "Home"{
        let listCategoriesInt: [Int] = listCategoriesSelected.map({ return $0.rawValue })
        defaults.set(fromDate, forKey: Const.NSUserDefaultsKey.fromDateForHome)
        defaults.set(toDate, forKey: Const.NSUserDefaultsKey.toDateForHome)
            defaults.set(listCategoriesInt, forKey: Const.NSUserDefaultsKey.categoriesForHome)}
        if pageType == "Search"{
        let listCategoriesInt: [Int] = listCategoriesSelected.map({ return $0.rawValue })
        defaults.set(fromDate, forKey: Const.NSUserDefaultsKey.fromDateForSearch)
        defaults.set(toDate, forKey: Const.NSUserDefaultsKey.toDateForSearch)
            defaults.set(listCategoriesInt, forKey: Const.NSUserDefaultsKey.categoriesForSearch)}

    }
    
    private func loadFilter(pageType:String) {
        
        let defaults = UserDefaults.standard
        
        if pageType == "Home"{
        if let date = defaults.object(forKey: Const.NSUserDefaultsKey.fromDateForHome) as? Date {
            fromDate = date
        }
        
        if let date = defaults.object(forKey: Const.NSUserDefaultsKey.toDateForHome) as? Date {
            toDate = date
        }
        if let categoryListInt = defaults.object(forKey: Const.NSUserDefaultsKey.categoriesForHome) as? [Int] {
            listCategoriesSelected = categoryListInt
                .map({ return CategoryType(rawValue: $0) })
                .compactMap { $0 }
            }
        }

        if pageType == "Search"{
        if let date = defaults.object(forKey: Const.NSUserDefaultsKey.fromDateForSearch) as? Date {
            fromDate = date
        }
        
        if let date = defaults.object(forKey: Const.NSUserDefaultsKey.toDateForSearch) as? Date {
            toDate = date
        }
        if let categoryListInt = defaults.object(forKey: Const.NSUserDefaultsKey.categoriesForSearch) as? [Int] {
            listCategoriesSelected = categoryListInt
                .map({ return CategoryType(rawValue: $0) })
                .compactMap { $0 }
            }
        }
        }
}
