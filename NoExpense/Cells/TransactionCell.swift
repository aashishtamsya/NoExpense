//
//  TransactionCell.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import RxSwift

final class TransactionCell: UITableViewCell {
  @IBOutlet weak fileprivate var categoryImageView: UIImageView!
  @IBOutlet weak fileprivate var categoryLabel: UILabel!
  @IBOutlet weak fileprivate var amountLabel: UILabel!
  @IBOutlet weak fileprivate var noteLabel: UILabel!
  @IBOutlet weak fileprivate var addedDateLabel: UILabel!
  
  private var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    disposeBag = DisposeBag()
    super.prepareForReuse()
  }
  
  func configure(with transaction: TransactionItem) {
    transaction.rx.observe(String.self, "amount")
      .bind(to: amountLabel.rx.text)
      .disposed(by: disposeBag)
    
    transaction.rx.observe(String.self, "category")
      .bind(to: categoryLabel.rx.text)
      .disposed(by: disposeBag)
    
    transaction.rx.observe(String.self, "note")
      .bind(to: noteLabel.rx.text)
      .disposed(by: disposeBag)
    
    transaction.rx.observe(Date.self, "added")
      .map { $0?.friendlyDateString ?? "Today" }
      .bind(to: addedDateLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
