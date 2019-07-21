//
//  TransactionItem.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class TransactionItem: Object {
  @objc dynamic var uid = 0
  @objc dynamic var category = "Other"
  var categoryType: CategoryType {
    get {
      return CategoryType(rawValue: category.lowercased()) ?? .other
    }
  }
  @objc dynamic var added = Date()
  @objc dynamic var note = ""
  @objc dynamic var amount = 0
  @objc dynamic var imagePath = ""
  
  var amountString: String {
    get { return "\(amount)" }
  }
  
  override class func primaryKey() -> String? {
    return "uid"
  }
}

extension TransactionItem: IdentifiableType {
  var identity: Int {
    return self.isInvalidated ? 0 : uid
  }
}
