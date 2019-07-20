//
//  CategoryType.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit

enum CategoryType: String {
  case other, travel, family, entertainment, home, food, drink, bills, car, utility, shopping, healthcare, clothing, vegetables, accommodation, transport, hobbies, education, pets, kids, vacation, gifts
  
  var image: UIImage? {
    get {
      return UIImage(named: rawValue)
    }
  }
    
  var color: UIColor {
    get {
      switch self {
      case .other:
        return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
      case .travel:
        return #colorLiteral(red: 0.1184935048, green: 0.1185710803, blue: 0.1237265691, alpha: 1)
      case .family:
        return #colorLiteral(red: 0.9053986669, green: 0.8476210237, blue: 0.2607384324, alpha: 1)
      case .entertainment:
        return #colorLiteral(red: 0.4444718361, green: 0.02017752081, blue: 0.5369205475, alpha: 1)
      case .home:
        return #colorLiteral(red: 0.8832754493, green: 0.4281875193, blue: 0.1349005699, alpha: 1)
      case .food:
        return #colorLiteral(red: 0.5916008353, green: 0.7919155955, blue: 0.9016838074, alpha: 1)
      case .drink:
        return #colorLiteral(red: 0.7187553644, green: 0.1151124164, blue: 0.1963596344, alpha: 1)
      case .bills:
        return #colorLiteral(red: 0.7603600621, green: 0.7571777701, blue: 0.5062331557, alpha: 1)
      case .car:
        return #colorLiteral(red: 0.4980303049, green: 0.5019547343, blue: 0.5175585151, alpha: 1)
      case .utility:
        return #colorLiteral(red: 0.3856558204, green: 0.6747731566, blue: 0.2908978462, alpha: 1)
      case .shopping:
        return #colorLiteral(red: 0.8364246488, green: 0.4940592647, blue: 0.6978248954, alpha: 1)
      case .healthcare:
        return #colorLiteral(red: 0.2633402348, green: 0.430742979, blue: 0.7094315886, alpha: 1)
      case .clothing:
        return #colorLiteral(red: 0.8673939109, green: 0.5455245376, blue: 0.4316363633, alpha: 1)
      case .vegetables:
        return #colorLiteral(red: 0.2919239104, green: 0.06708414108, blue: 0.5917641521, alpha: 1)
      case .accommodation:
        return #colorLiteral(red: 0.8904895186, green: 0.6554791331, blue: 0.2172204256, alpha: 1)
      case .transport:
        return #colorLiteral(red: 0.5660751462, green: 0.02081694081, blue: 0.548704803, alpha: 1)
      case .hobbies:
        return #colorLiteral(red: 0.9048720002, green: 0.9534732699, blue: 0.3739720583, alpha: 1)
      case .education:
        return #colorLiteral(red: 0.4987957478, green: 0.0949466899, blue: 0.08275242895, alpha: 1)
      case .pets:
        return #colorLiteral(red: 0.5672152638, green: 0.717995286, blue: 0.283308506, alpha: 1)
      case .kids:
        return #colorLiteral(red: 0.4278761744, green: 0.2199401557, blue: 0.08675994724, alpha: 1)
      case .vacation:
        return #colorLiteral(red: 0.7972297072, green: 0.193308413, blue: 0.1691967547, alpha: 1)
      case .gifts:
        return #colorLiteral(red: 0.1720129251, green: 0.2314941287, blue: 0.0826440081, alpha: 1)
      }
    }
  }
  
  static let items: [CategoryType] = [.other, .travel, .family, .entertainment, .home, .food, .drink, .bills, .car, .utility, .shopping, .healthcare, .clothing, .vegetables, .accommodation, .transport, .hobbies, .education, .pets, .kids, .vacation, .gifts]
  
  static let stringValues: [String] = CategoryType.items.map { $0.rawValue.capitalized }
  
  static func category(at index: Int) -> CategoryType? {
    guard index < items.count else { return nil }
    return items[index]
  }
  
  static func index(of category: CategoryType) -> Int {
    return items.firstIndex(of: category) ?? 0
  }
}
