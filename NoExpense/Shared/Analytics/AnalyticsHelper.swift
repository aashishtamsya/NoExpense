//
//  AnalyticsHelper.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 04/08/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation
import FirebaseAnalytics

// MARK: - Analytics Helper Methods
/// Provides interface to log event asynchronously.
///
/// - Parameters:
///   - eventType: type of event.
///   - parameters: parameters associated with the event.
func logEventAsync(eventType: AnalyticsEvent, parameters: [String: Any]? = nil) {
  DispatchQueue.global(qos: .background).async {
    Analytics.logEvent(eventType.rawValue, parameters: parameters)
  }
}
