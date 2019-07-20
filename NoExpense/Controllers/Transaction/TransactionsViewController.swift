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
  
  @IBOutlet weak fileprivate var emptyButton: UIButton!
  @IBOutlet weak fileprivate var emptyStackView: UIStackView!
  @IBOutlet weak fileprivate var expenseStackView: UIStackView!
  @IBOutlet weak fileprivate var totalExpenseStackView: UIStackView!
  @IBOutlet weak fileprivate var thisMonthExpenseStackView: UIStackView!
  @IBOutlet weak fileprivate var tableView: UITableView!
  @IBOutlet weak fileprivate var newTransactionButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var totalExpenseLabel: UILabel!
  @IBOutlet weak fileprivate var thisMonthExpenseLabel: UILabel!
  @IBOutlet weak fileprivate var totalExpenseButton: UIButton!
  @IBOutlet weak fileprivate var thisMonthExpenseButton: UIButton!

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
    newTransactionButton.rx.action = viewModel.onCreateTransaction()
    emptyButton.rx.action = viewModel.onCreateTransaction()
    totalExpenseButton.rx.action = viewModel.expense(of: .totalExpense)
    thisMonthExpenseButton.rx.action = viewModel.expense(of: .thisMonth)
    
    bindTableView()
    bindExpensesUI()
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
  
  fileprivate func bindTableView() {
    viewModel.sectionItems
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: rx.disposeBag)
    
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
  }
  
  fileprivate func bindExpensesUI() {
    let totalExpenseShared = viewModel.expenseStatistics
      .map { $0.total }
      .share()
    
    totalExpenseShared
      .map { "-\($0)" }
      .bind(to: totalExpenseLabel.rx.text)
      .disposed(by: rx.disposeBag)
    
    totalExpenseShared
      .map { $0 == 0 }
      .bind(to: thisMonthExpenseStackView.rx.isHidden)
      .disposed(by: rx.disposeBag)
    
    let thisMonthExpenseShared = viewModel.expenseStatistics
      .map { $0.thisMonth }
      .share()
    
    thisMonthExpenseShared
      .map { "-\($0)" }
      .bind(to: thisMonthExpenseLabel.rx.text)
      .disposed(by: rx.disposeBag)
    
    thisMonthExpenseShared
      .map { $0 == 0 }
      .bind(to: thisMonthExpenseStackView.rx.isHidden)
      .disposed(by: rx.disposeBag)
    
    let isTransactionsEmpty = Observable.combineLatest(totalExpenseShared, thisMonthExpenseShared) { $0 == 0 && $1 == 0 }.share()
    
    isTransactionsEmpty
      .bind(to: expenseStackView.rx.isHidden)
      .disposed(by: rx.disposeBag)
    
    isTransactionsEmpty
      .map { !$0 }
      .bind(to: emptyStackView.rx.isHidden)
      .disposed(by: rx.disposeBag)
    
  }
}
