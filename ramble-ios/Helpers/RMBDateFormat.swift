//
//  RMBDateFormat.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-09.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

enum RMBDateFormat {
    case mdySimple, monthDayYear, monthYear, fullFormat, weekdayMonthDay, weekdayMonthDayHour, dayMonth, hourMin, monthDay
    
    func formatted(date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        
        switch self {
        case .mdySimple: formatter.dateFormat = "MM-dd-yyyy"
        case .monthDayYear: formatter.dateFormat = "MMM d, yyyy"
        case .monthYear: formatter.dateFormat = "MMM yyyy"
        case .fullFormat: formatter.dateFormat = "\("weekdayMonthDayFormat".localized), h:mm a"
        case .weekdayMonthDay: formatter.dateFormat = "weekdayMonthDayFormat".localized
        case .weekdayMonthDayHour: formatter.dateFormat = "\("weekdayMonthDayFormat".localized), h:mm a"
        case .dayMonth:
            if date.isToday {
                return "today".localized
            }
            formatter.dateFormat = "dd MMM"
        case .monthDay:
                if date.isToday {
                    return "today".localized
                }
                formatter.dateFormat = "MMM d"
        case .hourMin:
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            formatter.dateFormat = "h:mm a"
        }
//        print(formatter.string(from: date))
        return formatter.string(from: date)
    }
    
    func combineDateAndHourWithAt(date: Date?, with anotherDate: Date, type: RMBDateFormat) -> String {
        return "\(self.formatted(date: date)) \("at".localized) \(type.formatted(date: anotherDate))"
    }
    
    // Saturday, May 5, 9pm to Monday, May 10, 12am
    // Thursday, Dec 6, 9:00 AM to 12:00 PM
    func combineStartAtAndEndAt(startAt: Date, endAt: Date, type: RMBDateFormat) -> String {
        
        if Calendar.current.isDate(startAt, inSameDayAs: endAt) {
            return "\(self.formatted(date: startAt).capitalizingFirstLetter()) \("to".localized) \(RMBDateFormat.hourMin.formatted(date: endAt).capitalizingFirstLetter())"
            
        } else {
            return "\(self.formatted(date: startAt).capitalizingFirstLetter()) \("to".localized) \(type.formatted(date: endAt).capitalizingFirstLetter())"
        }
    }
}
