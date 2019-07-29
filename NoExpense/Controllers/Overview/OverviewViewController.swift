//
//  OverviewViewController.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 20/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import PieCharts

final class OverviewViewController: ViewController, BindableType {
  @IBOutlet weak fileprivate var totalExpenseChart: PieChart!
  @IBOutlet weak fileprivate var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var totalExpenseLabel: UILabel!
  
  var viewModel: OverviewViewModel!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    logEventAsync(eventType: .overview_viewed, parameters: ["type": viewModel.overviewType.rawValue])
  }
  
  func bindViewModel() {
    cancelBarButton.rx.action = viewModel.onCancel
    totalExpenseChart.layers = viewModel.pieChartLayers
    
    viewModel.expenses
      .map { $0.expenseString }
      .bind(to: totalExpenseLabel.rx.text)
      .disposed(by: rx.disposeBag)
    
    viewModel.slices
      .subscribe(onNext: { models in
        self.totalExpenseChart.models = models
      })
      .disposed(by: rx.disposeBag)
  }
}
