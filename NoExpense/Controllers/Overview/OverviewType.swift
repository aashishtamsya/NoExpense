//
//  OverviewType.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 21/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation

enum OverviewType: String {
  case totalExpense = "TotalExpense"
  case thisMonth = "ThisMonth"
  
  var title: String {
    get {
      return rawValue.localized
    }
  }
}
