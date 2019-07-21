//
//  TransactionServiceType.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

enum TransactionServiceError: Error {
  case creationFailed
  case updateFailed(TransactionItem)
  case deletionFailed(TransactionItem)
}

typealias ExpenseStatistics = (total: Int, thisMonth: Int)

protocol TransactionServiceType {
  @discardableResult
  func create(amount: Int) -> Observable<TransactionItem>
  
  @discardableResult
  func delete(transaction: TransactionItem) -> Observable<Void>
  
  @discardableResult
  func update(transcation: TransactionItem, updateInfo: UpdateInfo) -> Observable<TransactionItem>
  
  @discardableResult
  func update(transcation: TransactionItem, imagePath: String) -> Observable<TransactionItem>
  
  func transactions() -> Observable<Results<TransactionItem>>
  
  func transactionsThisMonth() -> Observable<Results<TransactionItem>>
  func expensesThisMonth() -> Observable<Int>
  func totalExpenses() -> Observable<Int>
  func expenseStatistics() -> Observable<ExpenseStatistics>
}
