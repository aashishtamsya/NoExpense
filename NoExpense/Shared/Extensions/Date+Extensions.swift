//
//  Date+Extensions.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation
import SwiftDate

/// Cached Calender used for calulating the colloquial time string.
private var cachedCalendar: Calendar?

extension Date {
  /// Provide friendly date string to display the relative time from the time when user views the content.
  var friendlyDateString: String? {
    return toRelative(style: RelativeFormatter.defaultStyle(), locale: Locale.current)
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
  func checkForToday(fromCalendar calendar: Calendar) -> Bool {
    let startOfDay = calendar.startOfDay(for: Date())
    let diff = calendar.dateComponents([.day], from: self, to: startOfDay).day ?? 0
    return diff < 0 ? false : (diff < 1)
  }
  
  func startDateOfCurrentMonth(from calendar: Calendar) -> Date? {
    let components = calendar.dateComponents([.year, .month], from: self)
    let startOfMonth = calendar.date(from: components)
    return startOfMonth
  }
  func endDateOfCurrentMonth(from calendar: Calendar) -> Date? {
    guard let startOfMonth = startOfCurrentMonth else { return nil }
    var components = calendar.dateComponents([.year, .month], from: self)
    components.month = 1
    components.day = -1
    let endOfMonth = calendar.date(byAdding: components, to: startOfMonth)
    return endOfMonth
  }
}
