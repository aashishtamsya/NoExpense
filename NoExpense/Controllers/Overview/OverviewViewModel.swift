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
  let overviewType: OverviewType

  let onCancel: CocoaAction?
  let disposeBag = DisposeBag()
  let categories = Observable.just(CategoryType.stringValues)
  
  let pieChartLayers: [PieChartLayer] = {
    return [OverviewViewModel.createCustomViewsLayer()]
  }()
  
  init(type overviewType: OverviewType, service transcationService: TransactionServiceType, coordinator: SceneCoordinatorType, cancelAction: CocoaAction? = nil) {
    self.transactionService = transcationService
    self.overviewType = overviewType
    
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
    return self.transactionService
      .transactions()
      .map { results in
        return results.toArray()
    }
  }
  
  var expenses: Observable<Int> {
    return self.transactionService
      .expenseStatistics()
      .map {  stats in
        switch self.overviewType {
        case .thisMonth:
          return stats.thisMonth
        case .totalExpense:
          return stats.total
        }
    }
  }
  
  var slices: Observable<[PieSliceModel]> {
    switch overviewType {
    case .thisMonth:
      return self.transactionService.transactionsThisMonth()
        .map { results in
          let segments = results.toArray().reduce(into: [:]) { $0[$1.categoryType, default: 0] += $1.amount }
          let slices: [PieSliceModel] = segments.reduce(into: []) { $0.append(PieSliceModel(value: Double($1.value), color: $1.key.color.withAlphaComponent(0.5), obj: $1.key))  }
          return slices
      }
    case .totalExpense:
      return self.transactionService.transactions()
        .map { results in
          let segments = results.toArray().reduce(into: [:]) { $0[$1.categoryType, default: 0] += $1.amount }
          let slices: [PieSliceModel] = segments.reduce(into: []) { $0.append(PieSliceModel(value: Double($1.value), color: $1.key.color.withAlphaComponent(0.5), obj: $1.key))  }
          return slices
      }
    }
  }
}

private extension OverviewViewModel {
  static func createTextLayer() -> PiePlainTextLayer {
    let textLayerSettings = PiePlainTextLayerSettings()
    textLayerSettings.viewRadius = 50
    textLayerSettings.hideOnOverflow = true
    textLayerSettings.label.font = UIFont.systemFont(ofSize: 12)
    textLayerSettings.label.textColor = .darkGray
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 1
    textLayerSettings.label.textGenerator = {slice in
      return formatter.string(from: slice.data.percentage * 100 as NSNumber).map { "\($0)%" } ?? ""
    }
    
    let textLayer = PiePlainTextLayer()
    textLayer.settings = textLayerSettings
    return textLayer
  }
  
  static func createCustomViewsLayer() -> PieCustomViewsLayer {
    let viewLayer = PieCustomViewsLayer()
    
    let settings = PieCustomViewsLayerSettings()
    settings.viewRadius = 120
    settings.hideOnOverflow = false
    viewLayer.settings = settings
    
    viewLayer.viewGenerator = createViewGenerator()
    return viewLayer
  }
  
  static func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
    return { slice, center in
      guard let category = slice.data.model.obj as? CategoryType else { return UIView() }
      let container = UIView()
      container.frame.size = CGSize(width: 100, height: 40)
      container.center = center
      let view = UIImageView()
      view.tintColor = category.color
      view.frame = CGRect(x: 30, y: 0, width: 36, height: 36)
      view.roundCorners()
      view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
      view.layer.borderWidth = 1
      container.addSubview(view)
      
      let specialTextLabel = UILabel()
      specialTextLabel.textColor = category.color.withAlphaComponent(0.8)
      specialTextLabel.textAlignment = .center
      let formatter = NumberFormatter()
      formatter.maximumFractionDigits = 1
      specialTextLabel.text = formatter.string(from: slice.data.percentage * 100 as NSNumber).map { "\($0)%" } ?? ""
      specialTextLabel.sizeToFit()
      specialTextLabel.frame = CGRect(x: 0, y: 40, width: 100, height: 20)
      container.addSubview(specialTextLabel)
      container.frame.size = CGSize(width: 100, height: 60)
      view.image = category.image
      return container
    }
  }
}
