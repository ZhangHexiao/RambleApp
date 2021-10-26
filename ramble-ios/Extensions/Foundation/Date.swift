//
//  Date.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-03.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

// MARK: - Helpers
extension Date {
    func timestamp() -> Int64 {

        return Int64(self.timeIntervalSince1970 * 1000)
    }
    static func date(timestamp: Int64) -> Date {

        let interval = TimeInterval(TimeInterval(timestamp) / 1000)
        return Date(timeIntervalSince1970: interval)
    }
    
    func adding(hours: Int) -> Date? {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)
    }
    
    static func endDateDefault() -> Date? {
        let dateAsString = "11:59 PM"
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "h:mm a"
        return Date.combine(date: Date(), time: dateFormatter.date(from: dateAsString) ?? Date())
    }
    
    public var isToday: Bool {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self) == formatter.string(from: now)
    }
    
    public var fullFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        return formatter.string(from: self)
    }
    
    public var fullFormatForNotifications: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
         return formatter.string(from: self)
    }
    
    public var isInPast: Bool {
        return self.timeIntervalSinceNow < 0
    }
    
    public var isInFuture: Bool {
        return self.timeIntervalSinceNow > 0
    }
    
    public var isWithin24Hours: Bool {
        if let tomorrow = Date().adding(hours: 24) {
            return self < tomorrow && self >= Date()
        }
        return false
    }
    
    func equals(_ date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
//        print(formatter.string(from: self))
//        print(formatter.string(from: date))
        return formatter.string(from: self) == formatter.string(from: date)
    }
}

extension Date {
    static func combine(date: Date, time: Date) -> Date? {
        
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year
        mergedComponments.month = dateComponents.month
        mergedComponments.day = dateComponents.day
        mergedComponments.hour = timeComponents.hour
        mergedComponments.minute = timeComponents.minute
        mergedComponments.second = timeComponents.second
        
        return calendar.date(from: mergedComponments)
    }
}

extension Date {
    // swiftlint:disable:next cyclomatic_complexity
    func timeAgoSinceDate(numericDates: Bool) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        if let year = components.year {
            if year >= 2 {
                return "\(year) " + ("years ago".localized)
            } else if year >= 1 {
                return stringToReturn(flag: numericDates, strings: ("1 year ago".localized, "Last year".localized))
            }
        }
        
        if let month = components.month {
            if month >= 2 {
                return "\(month) " + ("months ago".localized)
            } else if month == 1 {
                return stringToReturn(flag: numericDates, strings: ("1 month ago".localized, "Last month".localized))
            }
        }
        
        if let weekOfYear = components.weekOfMonth {
            if weekOfYear >= 2 {
                return "\(weekOfYear) " + ("weeks ago".localized)
            } else if weekOfYear == 1 {
                return stringToReturn(flag: numericDates, strings: ("1 week ago".localized, "Last week".localized))
            }
        }
        
        if let day = components.day {
            if day >= 2 {
                return "\(day) " + ("days ago".localized)
            } else if day == 1 {
                return stringToReturn(flag: numericDates, strings: ("1 day ago".localized, "Yesterday".localized))
            }
        }
        
        if let hour = components.hour {
            if hour >= 2 {
                return "\(hour) " + ("hours ago".localized)

            } else if hour == 1 {
                return stringToReturn(flag: numericDates, strings: ("1 hour ago".localized, "An hour ago".localized))
            }
        }
        
        if let minute = components.minute {
            if minute >= 2 {
                return "\(minute) " + ("minutes ago".localized)

            } else if minute == 1 {
                return stringToReturn(flag: numericDates, strings: ("1 minute ago".localized, "A minute ago".localized))
            }
        }
        
        if let second = components.second {
            if second >= 3 {
                return "\(second) seconds ago"
            }
        }
        
        return "Just now".localized
    }
    
    private func stringToReturn(flag: Bool, strings: (String, String)) -> String {
        if flag {
            return strings.0
        } else {
            return strings.1
        }
    }
}

extension Date {
    func absoluteDaysDifference(from date: Date) -> Int {
        let startOfDay1 = Calendar.current.startOfDay(for: self)
        let startOfDay2 = Calendar.current.startOfDay(for: date)
        return Calendar.current.dateComponents([.day], from: startOfDay2, to: startOfDay1).day ?? 0
    }
}

extension Date {
    var hour: Int {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour], from: self)
        return comp.hour ?? 0
    }
    
    var mins: Int {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.minute], from: self)
        return comp.minute ?? 0
    }
    
    var year: Int {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.year], from: self)
        return comp.year ?? 0
    }
    
    var month: Int {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.month], from: self)
        return comp.month ?? 0
    }
    
    var day: Int {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.day], from: self)
        return comp.day ?? 0
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> Bool {
        if days(from: date) == 0 {
            if hours(from: date) <= 24 && minutes(from: date) > 0 { return true }
        }
        return false
    }
}
