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
  @IBOutlet weak fileprivate var photoView: UIView!
  @IBOutlet weak fileprivate var photoImageView: UIImageView!
  
  private var disposeBag = DisposeBag()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureUI()
  }
  
  override func prepareForReuse() {
    disposeBag = DisposeBag()
    super.prepareForReuse()
    configureUI()
  }
  
  func configure(with transaction: TransactionItem) {
    categoryImageView.backgroundColor = transaction.categoryType.color

    transaction.rx.observe(Int.self, "amount")
      .map { ($0 ?? 0).expenseString }
      .bind(to: amountLabel.rx.text)
      .disposed(by: disposeBag)
    
    transaction.rx.observe(String.self, "category")
      .bind(to: categoryLabel.rx.text)
      .disposed(by: disposeBag)
    
    transaction.rx.observe(String.self, "note")
      .bind(to: noteLabel.rx.text)
      .disposed(by: disposeBag)
    
    transaction.rx.observe(String.self, "category")
      .map { CategoryType.type($0 ?? "")?.image }
      .bind(to: categoryImageView.rx.image)
      .disposed(by: disposeBag)
    
    transaction.rx.observe(String.self, "imagePath")
      .map { $0?.isEmpty ?? true }
      .bind(to: photoView.rx.isHidden)
      .disposed(by: disposeBag)
    
    transaction.rx.observe(String.self, "imagePath")
      .map { UIImage.load(fileName: $0 ?? "") }
      .bind(to: photoImageView.rx.image)
      .disposed(by: disposeBag)
  }
}

private extension TransactionCell {
  func configureUI() {
    photoImageView.roundCorners(withRadius: 8)
    categoryImageView.backgroundColor = nil
    categoryImageView.roundCorners()
    categoryImageView.tintColor = .white
  }
}
