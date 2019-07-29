//
//  AnalyticsEvent.swift
//  Pods
//
//  Created by Aashish Tamsya on 04/08/19.
//

import Foundation

/// Represents the type of Analytical Events.
enum AnalyticsEvent: String {
  case transaction_added
  case transaction_updated
  case transaction_removed
  
  case edit_transaction_viewed
  case transcation_list_viewed
  case overview_viewed
}
