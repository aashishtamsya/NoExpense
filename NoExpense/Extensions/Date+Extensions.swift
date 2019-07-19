//
//  Date+Extensions.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation

import Foundation

/// Cached Calender used for calulating the colloquial time string.
private var cachedCalendar: Calendar?

extension Date {
  /// Provide friendly date string to display the relative time from the time when user views the content.
  var friendlyDateString: String? {
    if let calendar = cachedCalendar {
      return getSinceTimeAgo(fromCalendar: calendar)
    } else {
      let calendar = Calendar.current
      cachedCalendar = calendar
      return getSinceTimeAgo(fromCalendar: calendar)
    }
  }
}

private extension Date {
  /// Calculates the colloquial time string with current time as a reference.
  ///
  /// - Parameter calendar: instance of calendar to retrieve the components of the time.
  /// - Returns: returns relative or colloquial time string
  func getSinceTimeAgo(fromCalendar calendar: Calendar) -> String? {
    let now = Date()
    if let interval = calendar.dateComponents([.year], from: self, to: now).year, interval > 0 {
      return interval == 1 ? String(format: "AYearAgo".localized, interval) : String(format: "YearsAgo".localized, interval)
    }
    if let interval = calendar.dateComponents([.month], from: self, to: now).month, interval > 0 {
      return interval == 1 ? String(format: "AMonthAgo".localized, interval) : String(format: "MonthsAgo".localized, interval)
    }
    if let interval = calendar.dateComponents([.weekdayOrdinal], from: self, to: now).weekdayOrdinal, interval > 0 {
      return interval == 1 ? String(format: "AWeekAgo".localized, interval) : String(format: "WeeksAgo".localized, interval)
    }
    if let interval = calendar.dateComponents([.day], from: self, to: now).day, interval > 0 {
      return interval == 1 ? String(format: "ADayAgo".localized, interval) : String(format: "DaysAgo".localized, interval)
    }
    if let interval = calendar.dateComponents([.hour], from: self, to: now).hour, interval > 0 {
      return interval == 1 ? String(format: "AHourAgo".localized, interval) : String(format: "HoursAgo".localized, interval)
    }
    if let interval = calendar.dateComponents([.minute], from: self, to: now).minute, interval > 0 {
      return interval == 1 ? String(format: "AMinuteAgo".localized, interval) : String(format: "MinutesAgo".localized, interval)
    }
    return "AMomentAgo".localized
  }
}
