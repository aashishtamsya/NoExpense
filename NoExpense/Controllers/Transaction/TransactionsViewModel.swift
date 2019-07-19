//
//  TransactionsViewModel.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation

struct TransactionsViewModel {
  let sceneCoordinator: SceneCoordinatorType
  let transactionService: TransactionServiceType
  
  init(transactionService: TransactionServiceType, coordinator: SceneCoordinatorType) {
    self.transactionService = transactionService
    self.sceneCoordinator = coordinator
  }
}
