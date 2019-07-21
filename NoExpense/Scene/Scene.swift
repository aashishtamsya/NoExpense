//
//  Scene.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation

enum Scene {
  case expenses(TransactionsViewModel)
  case editExpense(EditExpenseViewModel)
  case overview(OverviewViewModel)
}
