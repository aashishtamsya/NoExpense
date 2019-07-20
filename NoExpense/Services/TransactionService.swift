//
//  TransactionService.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

struct TransactionService: TransactionServiceType {
  @discardableResult
  func create(amount: Int) -> Observable<TransactionItem> {
    let result = withRealm("creating") { realm -> Observable<TransactionItem> in
      let transcation = TransactionItem()
      transcation.amount = amount
      try realm.write {
        transcation.uid = (realm.objects(TransactionItem.self).max(ofProperty: "uid") ?? 0) + 1
        realm.add(transcation)
      }
      return .just(transcation)
    }
    return result ?? .error(TransactionServiceError.creationFailed)
  }
  
  @discardableResult
  func delete(transaction: TransactionItem) -> Observable<Void> {
    let result = withRealm("deleting") { realm -> Observable<Void> in
      try realm.write {
        realm.delete(transaction)
      }
      return .empty()
    }
    return result ?? .error(TransactionServiceError.deletionFailed(transaction))
  }
  
  @discardableResult
  func update(transcation: TransactionItem, updateInfo: UpdateInfo) -> Observable<TransactionItem> {
    let result = withRealm("updating") { realm -> Observable<TransactionItem> in
      try realm.write {
        if let amount = Int(updateInfo.amount) {
          transcation.amount = amount
        }
        if let note = updateInfo.note {
          transcation.note = note
        }
        if let category = updateInfo.category {
          transcation.category = category
        }
        if let added = updateInfo.added {
          transcation.added = added
        }
      }
      return .just(transcation)
    }
    return result ?? .error(TransactionServiceError.updateFailed(transcation))
  }
  
  func transactions() -> Observable<Results<TransactionItem>> {
    let result = withRealm("getting transcations") { realm -> Observable<Results<TransactionItem>> in
      let realm = try Realm()
      let transactions = realm.objects(TransactionItem.self).sorted(byKeyPath: "added", ascending: false)    
      return Observable.collection(from: transactions)
    }
    return result ?? .empty()
  }
  
  func expensesThisMonth() -> Observable<Int> {
    let result = withRealm("expense of this month") { realm -> Observable<Int> in
      guard let startDate = Date().startOfCurrentMonth, let endDate = Date().endOfCurrentMonth else {
        return .empty()
      }
      let thisMonthTransactions = realm.objects(TransactionItem.self).filter("(added >= %@) AND (added < %@)", startDate, endDate)
      return Observable.collection(from: thisMonthTransactions).map { $0.sum(ofProperty: "amount") }
    }
    return result ?? .empty()
  }
  
  func totalExpenses() -> Observable<Int> {
    let result = withRealm("total expense") { realm -> Observable<Int> in
      let transactions = realm.objects(TransactionItem.self)
      return Observable.collection(from: transactions).map { $0.sum(ofProperty: "amount") }
    }
    return result ?? .empty()
  }
  
  func expenseStatistics() -> Observable<ExpenseStatistics> {
    let result = withRealm("expense statistics") { realm -> Observable<ExpenseStatistics> in
      guard let startDate = Date().startOfCurrentMonth, let endDate = Date().endOfCurrentMonth else {
        return .empty()
      }
      let transactions = realm.objects(TransactionItem.self)
      let thisMonthTransactions = realm.objects(TransactionItem.self).filter("(added >= %@) AND (added < %@)", startDate, endDate)
      return .combineLatest(
        Observable.collection(from: transactions)
          .map { $0.sum(ofProperty: "amount") },
        Observable.collection(from: thisMonthTransactions)
          .map { $0.sum(ofProperty: "amount")}) { total, thisMonth in
            (total: total, thisMonth: thisMonth)
          }
    }
    return result ?? .empty()
  }
  
  func transactionsThisMonth() -> Observable<Results<TransactionItem>> {
    let result = withRealm("expense of this month") { realm -> Observable<Results<TransactionItem>> in
      guard let startDate = Date().startOfCurrentMonth, let endDate = Date().endOfCurrentMonth else {
        return .empty()
      }
      let thisMonthTransactions = realm.objects(TransactionItem.self).filter("(added >= %@) AND (added < %@)", startDate, endDate)
      return Observable.collection(from: thisMonthTransactions)
    }
    return result ?? .empty()
  }
}

private extension TransactionService {
  func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
    do {
      let realm = try Realm()
      return try action(realm)
    } catch let err {
      print("❌ Failed \(operation) realm with error: \(err)")
      return nil
    }
  }
}
