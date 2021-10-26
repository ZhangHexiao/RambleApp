//
//  UserDefaults.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-11-27.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

enum TooltipType: String {
    case createEvent
    case filter
    case profile
}

extension UserDefaults {
    
    class func shouldShowToolTip(for tooltip: TooltipType) -> Bool {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: tooltip.rawValue) == false {
            defaults.set(true, forKey: tooltip.rawValue)
            return true
        } else {
            return false
        }
    }
    
    class func clearSearchFilter() {
       let defaults = UserDefaults.standard
       if defaults.object(forKey: Const.NSUserDefaultsKey.fromDateForSearch) != nil
       {
        defaults.removeObject(forKey: Const.NSUserDefaultsKey.fromDateForSearch)
        }
       if defaults.object(forKey:  Const.NSUserDefaultsKey.toDateForSearch) != nil
        {
         defaults.removeObject(forKey:  Const.NSUserDefaultsKey.toDateForSearch)
         }
       if defaults.object(forKey: Const.NSUserDefaultsKey.categoriesForSearch) != nil
        {
         defaults.removeObject(forKey: Const.NSUserDefaultsKey.categoriesForSearch)
         }
    }
    
    class func checkSearchFilter() -> Bool {
        let defaults = UserDefaults.standard
        return (defaults.object(forKey: Const.NSUserDefaultsKey.fromDateForSearch) != nil || defaults.object(forKey:  Const.NSUserDefaultsKey.toDateForSearch) != nil || defaults.object(forKey: Const.NSUserDefaultsKey.categoriesForSearch) != nil)
    }
    
    
    
}
