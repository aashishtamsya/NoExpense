//
//  EditExpenseViewModel.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation

struct EditExpenseViewModel {
  let amount: String
  
  init(transaction: TransactionItem) {
    amount = transaction.amount
  }
}
