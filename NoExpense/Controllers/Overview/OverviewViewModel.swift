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
import PieCharts

struct OverviewViewModel {
  let transactionService: TransactionServiceType
  
  let onCancel: CocoaAction?
  let disposeBag = DisposeBag()
  let categories = Observable.just(CategoryType.stringValues)
  
  init(transcationService: TransactionServiceType, coordinator: SceneCoordinatorType, cancelAction: CocoaAction? = nil) {
    self.transactionService = transcationService
    
    onCancel = CocoaAction {
      if let cancelAction =  cancelAction {
        cancelAction.execute()
      }
      return coordinator.pop()
        .asObservable()
        .map { _ in }
    }
  }
  
  var transactions: Observable<[TransactionItem]> {
    return self.transactionService.transactions()
      .map { results in
        return results.toArray()
    }
  }
  
  var slices: Observable<[PieSliceModel]> {
    return self.transactionService.transactions()
      .map { results in
        let segments = results.toArray().reduce(into: [:]) { $0[$1.categoryType, default: 0] += $1.amount }
        let slices: [PieSliceModel] = segments.reduce(into: []) { $0.append(PieSliceModel(value: Double($1.value), color: $1.key.color.withAlphaComponent(0.5), obj: $1.key))  }
        return slices
        
    }
  }
}
