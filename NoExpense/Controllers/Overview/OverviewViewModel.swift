//
//  OverviewViewModel.swift
//  
//
//  Created by Aashish Tamsya on 20/07/19.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RealmSwift

struct OverviewViewModel {
  let transactions: Results<TransactionItem>

  let onCancel: CocoaAction?
  let disposeBag = DisposeBag()
  let categories = Observable.just(CategoryType.stringValues)
  
  init(transactions: Results<TransactionItem>, coordinator: SceneCoordinatorType, cancelAction: CocoaAction? = nil) {
    self.transactions = transactions

    onCancel = CocoaAction {
      if let cancelAction =  cancelAction {
        cancelAction.execute()
      }
      return coordinator.pop()
        .asObservable()
        .map { _ in }
    }
  }
}
