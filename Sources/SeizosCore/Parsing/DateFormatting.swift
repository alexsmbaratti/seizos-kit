//
//  DateFormatting.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/28/25.
//

import Foundation


public extension Date {
    func formattedLongDate(timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
}
