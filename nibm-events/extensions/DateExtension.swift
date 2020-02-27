//
//  DateExtension.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/27/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import Foundation

extension Date {
        func timeAgo() -> String {
            let secondsAgo = Int(Date().timeIntervalSince(self))
            
            let minute = 60
            let hour = 60 * minute
            let day = 24 * hour
            let week = 7 * day
            
            let quotient: Int
            let unit: String
            
            if secondsAgo < minute {
                quotient = secondsAgo
                unit = "second"
            } else if secondsAgo < hour {
                quotient = secondsAgo / minute
                unit = "minute"
            } else if secondsAgo < day {
                quotient = secondsAgo / hour
                unit = "hour"
            } else if secondsAgo < week {
                quotient = secondsAgo / day
                unit = "day"
            } else {
                let df = DateFormatter()
                df.dateFormat = "MMMM d y"
                return df.string(from: self)
            }
            
            return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        }
}

