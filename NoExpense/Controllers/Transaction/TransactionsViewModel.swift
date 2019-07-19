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
import RealmSwift

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
  
  func onUpdate(transcation: TransactionItem) -> Action<UpdateInfo, Void> {
    return Action { newUpdateInfo in
      return self.transactionService.update(transcation: transcation, updateInfo: newUpdateInfo).map { _ in }
    }
  }
  
  func onCreateTransaction() -> CocoaAction {
    return CocoaAction { _ in
      return self.transactionService
        .create(amount: "")
        .flatMap({ transaction -> Observable<Void> in
          let editViewModel = EditExpenseViewModel(transaction: transaction, coordinator: self.sceneCoordinator, updateAction: self.onUpdate(transcation: transaction), cancelAction: self.onDelete(transaction: transaction))
          return self.sceneCoordinator.transition(to: Scene.editExpense(editViewModel), type: .modal)
            .asObservable()
            .map { _ in }
        })
    }
  }
  
  var sectionItems: Observable<[TransactionSection]> {
    return self.transactionService.transactions()
      .map { results in
        let sections = results.map {
          return Calendar.current.startOfDay(for: $0.added)
          }.reduce([]) { dates, date in
            return dates.last == date ? dates : dates + [date]
          }.compactMap { startDate -> (date: Date, items: Results<TransactionItem>)? in
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            let items = results.filter("(added >= %@) AND (added < %@)", startDate, endDate)
            return items.isEmpty ? nil : (date: startDate, items: items)
        }
        return sections.map { TransactionSection(model: $0.date.isToday ? "Today".localized : ( $0.date.friendlyDateString ?? ""), items: $0.items.toArray()) }
    }
  }
  
  lazy var editAction: Action<TransactionItem, Swift.Never> = { this in
    return Action { transaction in
      let editViewModel = EditExpenseViewModel(transaction: transaction, coordinator: this.sceneCoordinator, updateAction: this.onUpdate(transcation: transaction))
      return this.sceneCoordinator
        .transition(to: Scene.editExpense(editViewModel), type: .modal)
        .asObservable()
    }
  }(self)
  
  lazy var deleteAction: Action<TransactionItem, Void> = { (service: TransactionServiceType) in
    return Action { transaction in
      return service.delete(transaction: transaction)
    }
  }(self.transactionService)
}
