//
//  TransactionsViewController.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Action
import NSObject_Rx

final class TransactionsViewController: ViewController, BindableType {
  
  @IBOutlet weak fileprivate var tableView: UITableView!
  @IBOutlet weak fileprivate var newTransactionButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var totalExpenseLabel: UILabel!
  @IBOutlet weak fileprivate var thisMonthExpenseLabel: UILabel!
  @IBOutlet weak fileprivate var totalExpenseButton: UIButton!
  
  var viewModel: TransactionsViewModel!
  var dataSource: RxTableViewSectionedAnimatedDataSource<TransactionSection>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 60
    tableView.register(UINib(nibName: "TransactionCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
    
    configureDatasource()
    setEditing(true, animated: false)
  }
  
  func bindViewModel() {
    viewModel.sectionItems
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: rx.disposeBag)
    
    newTransactionButton.rx.action = viewModel.onCreateTransaction()
    
    totalExpenseButton.rx.action = viewModel.totalExpenseSelected()
    
    tableView.rx.itemSelected
      .map { [unowned self] indexPath in
        try! self.dataSource.model(at: indexPath) as! TransactionItem
      }
      .subscribe(viewModel.editAction.inputs)
      .disposed(by: rx.disposeBag)
    
    tableView.rx.itemDeleted
      .map { [unowned self] indexPath in
        try! self.dataSource.model(at: indexPath) as! TransactionItem
      }
      .subscribe(viewModel.deleteAction.inputs)
      .disposed(by: rx.disposeBag)
    
    viewModel.expenseStatistics.subscribe(onNext: { [weak self] stats in
      self?.totalExpenseLabel.text = "-\(stats.total)"
      self?.thisMonthExpenseLabel.text = "-\(stats.thisMonth)"
    })
    .disposed(by: rx.disposeBag)
  }
  
  fileprivate func configureDatasource() {
    dataSource = RxTableViewSectionedAnimatedDataSource<TransactionSection>(configureCell: { _, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
      cell.configure(with: item)
      return cell
    }, titleForHeaderInSection: { dataSource, index in
      dataSource.sectionModels[index].model
    }, canEditRowAtIndexPath: { _, _ in true })
  }
}
