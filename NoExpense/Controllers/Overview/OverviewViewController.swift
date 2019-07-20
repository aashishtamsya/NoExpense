//
//  OverviewViewController.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 20/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit

final class OverviewViewController: ViewController, BindableType {
  
  @IBOutlet weak var cancelBarButton: UIBarButtonItem!
  
  var viewModel: OverviewViewModel!
  
  func bindViewModel() {
    cancelBarButton.rx.action = viewModel.onCancel

  }
}
