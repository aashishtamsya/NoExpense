//
//  TransactionsViewController.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit

final class TransactionsViewController: ViewController, BindableType {
  
  @IBOutlet weak fileprivate var tableView: UITableView!
  
  var viewModel: TransactionsViewModel!
  
  func bindViewModel() {
    
  }
}
