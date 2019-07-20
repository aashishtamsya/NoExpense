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
  @IBOutlet weak fileprivate var dateField: UITextField!
  
  var viewModel: EditExpenseViewModel!
  fileprivate var datePicker = UIDatePicker()
  fileprivate var categoryPicker = UIPickerView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  func bindViewModel() {
    amountField.text = viewModel.transaction.amount == 0 ? "" : viewModel.transaction.amountString
    categoryField.text = viewModel.transaction.category
    noteField.text = viewModel.transaction.note
    dateField.text = viewModel.transaction.added.friendlyDateString
    datePicker.date = viewModel.transaction.added
    
    cancelBarButton.rx.action = viewModel.onCancel
    
    datePicker.rx.date
      .map { $0.friendlyDateString ?? "Today" }.bind(to: dateField.rx.text)
      .disposed(by: rx.disposeBag)
    
    viewModel.categories
      .bind(to: categoryPicker.rx.itemTitles) { _, item in
        return "\(item)"
      }
      .disposed(by: rx.disposeBag)
    
    categoryPicker.rx.modelSelected(String.self)
      .map { $0.first ?? "" }
      .bind(to: categoryField.rx.text)
      .disposed(by: rx.disposeBag)
    
    let updateInfo = Observable.combineLatest(amountField.rx.text, categoryField.rx.text, noteField.rx.text, datePicker.rx.date) { (amount, category, note, date) -> UpdateInfo in
      return UpdateInfo(amount: amount ?? "0", category: category, note: note, added: date)
    }
    
    amountField.rx.text.orEmpty
      .map { (Int($0) ?? 0) != 0 }
      .bind(to: doneBarButton.rx.isEnabled)
      .disposed(by: rx.disposeBag)
    
    doneBarButton.rx.tap
      .withLatestFrom(updateInfo)
      .subscribe(viewModel.onUpdate.inputs)
      .disposed(by: rx.disposeBag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    amountField.becomeFirstResponder()
  }
}
// MARK: - Private Methods
private extension EditExpenseViewController {
  func configureUI() {
    datePicker.datePickerMode = .date
    datePicker.maximumDate = Date().addingTimeInterval(31556926)
    datePicker.minimumDate = Date().addingTimeInterval(-31556926)
    dateField.inputView = datePicker
    categoryField.inputView = categoryPicker
  }
}
