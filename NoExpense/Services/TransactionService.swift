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
  init() {
    do {
      let realm = try Realm()
      if realm.objects(TransactionItem.self).isEmpty {
        ["34",
         "250",
         "123",
         "98",
         "46"].forEach {
          self.create(amount: $0)
        }
      }
    } catch _ {
    }
  }
  
  @discardableResult
  func create(amount: String) -> Observable<TransactionItem> {
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
  func delete(transaction: TransactionItem) -> Observable<Bool> {
    let result = withRealm("deleting") { realm -> Observable<Bool> in
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
        transcation.amount = updateInfo.amount
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
