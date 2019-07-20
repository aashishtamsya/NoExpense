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
import RxDataSources

final class EditExpenseViewController: ViewController, BindableType {
  @IBOutlet weak fileprivate var categoryImageView: UIImageView!
  @IBOutlet weak fileprivate var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var doneBarButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var amountField: UITextField!
  @IBOutlet weak fileprivate var categoryField: UITextField!
  @IBOutlet weak fileprivate var noteTextView: UITextView!
  //  @IBOutlet weak fileprivate var noteField: UITextField!
  @IBOutlet weak fileprivate var dateField: UITextField!
  @IBOutlet weak fileprivate var amountView: UIView!
  
  var viewModel: EditExpenseViewModel!
  fileprivate var datePicker = UIDatePicker()
  fileprivate var categoryPicker = UIPickerView()
  fileprivate var categoryPickerAdaptor: RxPickerViewStringAdapter<[String]>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  func bindViewModel() {
    amountField.text = viewModel.transaction.amount == 0 ? "" : viewModel.transaction.amountString
    categoryField.text = viewModel.transaction.category
    noteTextView.text = viewModel.transaction.note
    dateField.text = viewModel.transaction.added.friendlyDateString
    datePicker.date = viewModel.transaction.added
    amountView.backgroundColor = viewModel.transaction.categoryType.color
    categoryImageView.image = viewModel.transaction.categoryType.image
    
    cancelBarButton.rx.action = viewModel.onCancel

    categoryPicker.rx.itemSelected
      .subscribe(onNext: { [weak self] item in
        let category = CategoryType.category(at: item.row) ?? .other
        self?.categoryField.text = category.rawValue.capitalized
        self?.amountView.backgroundColor = category.color.withAlphaComponent(0.35)
        self?.categoryImageView.image = category.image
      })
      .disposed(by: rx.disposeBag)
    
    datePicker.rx.date
      .map { $0.friendlyDateString ?? "Today" }.bind(to: dateField.rx.text)
      .disposed(by: rx.disposeBag)
    
    viewModel.categories
      .bind(to: categoryPicker.rx.items(adapter: categoryPickerAdaptor))
      .disposed(by: rx.disposeBag)
    
    let updateInfo = Observable.combineLatest(amountField.rx.text.orEmpty.asObservable(), categoryField.rx.text.orEmpty.asObservable(), noteTextView.rx.text.orEmpty.asObservable(), datePicker.rx.date.asObservable()) { (amount, category, note, date) -> UpdateInfo in
      return UpdateInfo(amount: amount, category: category, note: note, added: date)
    }
    
    amountField.rx.text.orEmpty.map { !$0.isEmpty }
      .bind(to: doneBarButton.rx.isEnabled)
      .disposed(by: rx.disposeBag)
    
    doneBarButton.rx.tap
      .withLatestFrom(updateInfo)
      .subscribe(viewModel.onUpdate.inputs)
      .disposed(by: rx.disposeBag)
    
    categoryPicker.selectRow(CategoryType.index(of: viewModel.transaction.categoryType), inComponent: 0, animated: true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    amountField.becomeFirstResponder()
  }
}
// MARK: - Private Methods
private extension EditExpenseViewController {
  func configureUI() {
    amountField.textColor = .darkGray
    categoryImageView.tintColor = .white
    datePicker.datePickerMode = .date
    datePicker.maximumDate = Date().addingTimeInterval(31556926)
    datePicker.minimumDate = Date().addingTimeInterval(-31556926)
    dateField.inputView = datePicker
    
    categoryPickerAdaptor = RxPickerViewStringAdapter<[String]>(components: [], numberOfComponents: { (_, _, _) -> Int in
      return 1
    }, numberOfRowsInComponent: { (_, _, items, _) -> Int in
      return items.count
    }, titleForRow: { (_, _, items, row, _) -> String? in
      return items[row]
    })
    
    categoryField.inputView = categoryPicker
  }
}
