//
//  CategoryType.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit

enum CategoryType: String {
  case travel, family, entertainment, home, food, drink, bills, car, utility, shopping, healthcare, clothing, vegetables, accommodation, other, transport, hobbies, education, pets, kids, vacation, gifts
  
  var image: UIImage? {
    get {
      return UIImage(named: rawValue)
    }
  }
  
  static let items: [CategoryType] = [.travel, .family, .entertainment, .home, .food, .drink, .bills, .car, .utility, .shopping, .healthcare, .clothing, .vegetables, .accommodation, .other, .transport, .hobbies, .education, .pets, .kids, .vacation, .gifts]
  
  static let stringValues: [String] = CategoryType.items.map { $0.rawValue.capitalized }
}
