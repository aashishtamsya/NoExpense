//
//  TransactionsViewModel.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

typealias TransactionSection = AnimatableSectionModel<String, TransactionItem>

struct TransactionsViewModel {
  let sceneCoordinator: SceneCoordinatorType
  let transactionService: TransactionServiceType
  
  init(transactionService: TransactionServiceType, coordinator: SceneCoordinatorType) {
    self.transactionService = transactionService
    self.sceneCoordinator = coordinator
  }
  
  func onDelete(transaction: TransactionItem) -> CocoaAction {
    return CocoaAction {
      return self.transactionService.delete(transaction: transaction).map { _ in }
    }
  }
  
  func onUpdateAmount(transcation: TransactionItem) -> Action<String, Void> {
    return Action { newAmount in
      return self.transactionService.update(transcation: transcation, amount: newAmount).map { _ in }
    }
  }
  
  func onCreateTransaction() -> CocoaAction {
    return CocoaAction { _ in
      return self.transactionService
        .create(amount: "")
        .flatMap({ transaction -> Observable<Void> in
          let editViewModel = EditExpenseViewModel(transaction: transaction, coordinator: self.sceneCoordinator, updateAction: self.onUpdateAmount(transcation: transaction), cancelAction: self.onDelete(transaction: transaction))
          return self.sceneCoordinator.transition(to: Scene.editExpense(editViewModel), type: .modal)
            .asObservable()
            .map { _ in }
        })
    }
  }
  
  var sectionItems: Observable<[TransactionSection]> {
    return self.transactionService.transactions()
      .map { results in
        return [TransactionSection(model: "", items: results.toArray())]
    }
  }
}
