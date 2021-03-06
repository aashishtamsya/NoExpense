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
  
  lazy var expenseStatistics: Observable<ExpenseStatistics> = self.transactionService.expenseStatistics()
  
  init(transactionService: TransactionServiceType, coordinator: SceneCoordinatorType) {
    self.transactionService = transactionService
    self.sceneCoordinator = coordinator
  }
  
  func onDelete(transaction: TransactionItem) -> CocoaAction {
    logEventAsync(eventType: .transaction_removed)
    UserDefaults.standard.incrementShowAdCount()
    return CocoaAction {
      return self.transactionService.delete(transaction: transaction).map { _ in }
    }
  }
  
  func onUpdate(transcation: TransactionItem, isUpdate: Bool = false) -> Action<UpdateInfo, Void> {
    _ = isUpdate ? logEventAsync(eventType: .transaction_updated) : logEventAsync(eventType: .transaction_added)
    if isUpdate {
      UserDefaults.standard.incrementShowAdCount()
    }
    return Action { newUpdateInfo in
      return self.transactionService.update(transcation: transcation, updateInfo: newUpdateInfo).map { _ in }
    }
  }
  
  func onCreateTransaction() -> CocoaAction {
    return CocoaAction { _ in
      return self.transactionService
        .create(amount: 0)
        .flatMap({ transaction -> Observable<Void> in
          let editViewModel = EditExpenseViewModel(transaction: transaction, service: self.transactionService, coordinator: self.sceneCoordinator, updateAction: self.onUpdate(transcation: transaction), cancelAction: self.onDelete(transaction: transaction))
          return self.sceneCoordinator.transition(to: .editExpense(editViewModel), type: .modal)
            .asObservable()
            .map { _ in }
        })
    }
  }
  
  func expense(of type: OverviewType) -> CocoaAction {
    return CocoaAction { _ in
      let overviewViewModel = OverviewViewModel(type: type, service: self.transactionService, coordinator: self.sceneCoordinator)
      return self.sceneCoordinator.transition(to: .overview(overviewViewModel), type: .modal)
        .asObservable()
        .map { _ in }
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
      let editViewModel = EditExpenseViewModel(transaction: transaction, service: this.transactionService, coordinator: this.sceneCoordinator, updateAction: this.onUpdate(transcation: transaction, isUpdate: true))
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
  
  var isEmpty: Observable<Bool> {
    return self.transactionService
      .transactions()
      .map { $0.isEmpty }
  }
}
