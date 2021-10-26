//
//  TimeConverter.swift
//  Created by Hexiao Zhang on 2020-04-22.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation

class TimeConvert: NSObject {

    class func dateToShort(_ date: Date) -> String {

        return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
    }


    class func timestampToMediumTime(_ timestamp: Int64) -> String {

        let date = Date.date(timestamp: timestamp)
        return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    }


    class func timestampToDayMonthTime(_ timestamp: Int64) -> String {

        let date = Date.date(timestamp: timestamp)

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, HH:mm"

        return formatter.string(from: date)
    }


    class func timestampToElapsed(_ timestamp: Date) -> String {

        var elapsed = ""

//        let date = Date.date(timestamp: timestamp)
        let seconds = Date().timeIntervalSince(timestamp)

        if seconds < 60 {
            elapsed = "Just now"
        } else if seconds < 60 * 60 {
            let minutes = Int(seconds / 60)
            let text = (minutes > 1) ? "mins" : "min"
            elapsed = "\(minutes) \(text)"
        } else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60 * 60))
            let text = (hours > 1) ? "hours" : "hour"
            elapsed = "\(hours) \(text)"
        } else if seconds < 7 * 24 * 60 * 60 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            elapsed = formatter.string(from: timestamp)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy"
            elapsed = formatter.string(from: timestamp)
        }

        return elapsed
    }
//========================
    
    class func timeCustomMessage(_ timestamp: Date) -> String {

        let seconds = Date().timeIntervalSince(timestamp)

        let formatter = DateFormatter()
        if seconds < 24 * 60 * 60 {
            formatter.dateFormat = "HH:mm"
        } else if seconds < 7 * 24 * 60 * 60 {
            formatter.dateFormat = "EEE"
        } else {
            formatter.dateFormat = "yyyy.MM.dd"
        }

        return formatter.string(from: timestamp)
    }
    
    class func denoteSendDate(_ timestamp: Date) -> String {

        let seconds = Date().timeIntervalSince(timestamp)

        let formatter = DateFormatter()
        if seconds < 24 * 60 * 60 {
            formatter.dateFormat = "HH:mm"
        }  else{
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return formatter.string(from: timestamp)
    }
}
