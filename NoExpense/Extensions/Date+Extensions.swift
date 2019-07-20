//
//  Date+Extensions.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

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
  
  var isToday: Bool {
    if let calendar = cachedCalendar {
      return checkForToday(fromCalendar: calendar)
    } else {
      let calendar = Calendar.current
      cachedCalendar = calendar
      return checkForToday(fromCalendar: calendar)
    }
  }
  
  var startOfCurrentMonth: Date? {
    get {
      if let calendar = cachedCalendar {
        return startDateOfCurrentMonth(from: calendar)
      } else {
        let calendar = Calendar.current
        cachedCalendar = calendar
        return startDateOfCurrentMonth(from: calendar)
      }
    }
  }
  
  var endOfCurrentMonth: Date? {
    get {
      if let calendar = cachedCalendar {
        return endDateOfCurrentMonth(from: calendar)
      } else {
        let calendar = Calendar.current
        cachedCalendar = calendar
        return endDateOfCurrentMonth(from: calendar)
      }
    }
  }
}

private extension Date {
  /// Calculates the colloquial time string with current time as a reference.
  ///
  /// - Parameter calendar: instance of calendar to retrieve the components of the time.
  /// - Returns: returns relative or colloquial time string
  func getSinceTimeAgo(fromCalendar calendar: Calendar) -> String? { // swiftlint:disable:this cyclomatic_complexity function_body_length
    guard !isToday else {
      return "Today".localized
    }
    let now = calendar.startOfDay(for: Date())
    if let interval = calendar.dateComponents([.year], from: self, to: now).year, interval > 0 {
      if interval > 0 {
        return interval == 1 ? String(format: "AYearAgo".localized, interval) : String(format: "YearsAgo".localized, interval)
      } else if interval < 0 {
        return interval == -1 ? String(format: "AYearBefore".localized, abs(interval)) : String(format: "YearsBefore".localized, abs(interval))
      }
    }
    if let interval = calendar.dateComponents([.month], from: self, to: now).month {
      if interval > 0 {
        return interval == 1 ? String(format: "AMonthAgo".localized, interval) : String(format: "MonthsAgo".localized, interval)
      } else if interval < 0 {
        return interval == -1 ? String(format: "AMonthBefore".localized, abs(interval)) : String(format: "MonthsBefore".localized, abs(interval))
      }
    }
    if let interval = calendar.dateComponents([.weekdayOrdinal], from: self, to: now).weekdayOrdinal {
      if interval > 0 {
        return interval == 1 ? String(format: "AWeekAgo".localized, interval) : String(format: "WeeksAgo".localized, interval)
      } else if interval < 0 {
        return interval == -1 ? String(format: "AWeekBefore".localized, abs(interval)) : String(format: "WeeksBefore".localized, abs(interval))
      }
    }
    if let interval = calendar.dateComponents([.day], from: self, to: now).day {
      if interval > 0 {
        return interval == 1 ? String(format: "ADayAgo".localized, interval) : String(format: "DaysAgo".localized, interval)
      } else if interval == 0 {
        return "Today".localized
      } else if interval < 0 {
        return interval == -1 ? String(format: "ADayBefore".localized, abs(interval)) : String(format: "DaysBefore".localized, abs(interval))
      }
    }
    if let interval = calendar.dateComponents([.hour], from: self, to: now).hour {
      print(interval)
      if interval > 0 {
        return interval == 1 ? String(format: "AHourAgo".localized, interval) : String(format: "HoursAgo".localized, interval)
      } else if interval == 0 {
        return "AMomentAgo".localized
      } else if interval < 0 {
        return interval == -1 ? String(format: "AHourBefore".localized, abs(interval)) : String(format: "HoursBefore".localized, abs(interval))
      }
    }
    if let interval = calendar.dateComponents([.minute], from: self, to: now).minute {
      if interval > 0 {
        return interval == 1 ? String(format: "AMinuteAgo".localized, interval) : String(format: "MinutesAgo".localized, interval)
      } else if interval == 0 {
        return "AMomentAgo".localized
      } else if interval < 0 {
        return interval == -1 ? String(format: "AMinuteBefore".localized, abs(interval)) : String(format: "MinutesBefore".localized, abs(interval))
      }
    }
    return "AMomentAgo".localized
  }
  
  func checkForToday(fromCalendar calendar: Calendar) -> Bool {
    let startOfDay = calendar.startOfDay(for: Date())
    let diff = calendar.dateComponents([.day], from: self, to: startOfDay).day ?? 0
    return diff < 0 ? false : (diff < 1)
  }
  
  func startDateOfCurrentMonth(from calendar: Calendar) -> Date? {
    let components = calendar.dateComponents([.year, .month], from: self)
    let startOfMonth = calendar.date(from: components)
    print(startOfMonth)
    return startOfMonth
  }
  func endDateOfCurrentMonth(from calendar: Calendar) -> Date? {
    guard let startOfMonth = startOfCurrentMonth else { return nil }
    var components = calendar.dateComponents([.year, .month], from: self)
    components.month = 1
    components.day = -1
    let endOfMonth = calendar.date(byAdding: components, to: startOfMonth)
    print(endOfMonth)
    return endOfMonth
  }
}
