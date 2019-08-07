//
//  Ad+Config.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 07/08/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation

func checkForAds() -> Bool {
  return UserDefaults.standard.showAddCount % 5 == 0
}

extension UserDefaults {
  var showAddCount: Int {
    return UserDefaults.standard.integer(forKey: "show_add_count")
  }
  
  func incrementShowAdCount() {
    var count = showAddCount
    count += 1
    UserDefaults.standard.set(count, forKey: "show_add_count")
  }
  
  func decrementShowAdCount(amount: Int) {
    var count = showAddCount
    if count < 0, count == 0 {
      count = 1
    } else {
      count -= amount
    }
    UserDefaults.standard.set(count, forKey: "show_add_count")
  }
}
