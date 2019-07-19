//
//  TransactionItem.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation
import RealmSwift

class TransactionItem: Object {
  @objc dynamic var uid = 0
  @objc dynamic var type = ""
  @objc dynamic var added = Date()
  @objc dynamic var note = ""
  @objc dynamic var amount = ""
  
  override class func primaryKey() -> String? {
    return "uid"
  }
}
