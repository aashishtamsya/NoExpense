//
//  EditExpenseViewModel.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCocoa

struct EditExpenseViewModel {
  let transaction: TransactionItem
  let onUpdate: Action<UpdateInfo, Void>!
  let onCancel: CocoaAction?
  let disposeBag = DisposeBag()
  let categories = Observable.just(CategoryType.stringValues)
  
  init(transaction: TransactionItem, coordinator: SceneCoordinatorType, updateAction: Action<UpdateInfo, Void>, cancelAction: CocoaAction? = nil) {
    self.transaction = transaction
    onUpdate = updateAction
    
    onUpdate.executionObservables
      .take(1)
      .subscribe { _ in
        coordinator.pop()
      }
      .disposed(by: disposeBag)
    
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
