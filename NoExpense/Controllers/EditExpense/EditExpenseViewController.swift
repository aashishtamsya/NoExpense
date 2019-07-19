//
//  EditExpenseViewController.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

final class EditExpenseViewController: ViewController, BindableType {
  @IBOutlet weak fileprivate var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var doneBarButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var amountField: UITextField!
  @IBOutlet weak fileprivate var categoryField: UITextField!
  @IBOutlet weak fileprivate var noteField: UITextField!
  
  var viewModel: EditExpenseViewModel!
  
  func bindViewModel() {
    amountField.text = viewModel.transaction.amount
    categoryField.text = viewModel.transaction.category
    noteField.text = viewModel.transaction.note
    
    cancelBarButton.rx.action = viewModel.onCancel
    
    let v = Observable.combineLatest(amountField.rx.text, categoryField.rx.text, noteField.rx.text) { (amount, category, note) -> UpdateInfo in
      return UpdateInfo(amount: amount ?? "", category: category, note: note)
    }
    
    doneBarButton.rx.tap
      .withLatestFrom(v)
      .subscribe(viewModel.onUpdate.inputs)
      .disposed(by: rx.disposeBag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    amountField.becomeFirstResponder()
  }
}
