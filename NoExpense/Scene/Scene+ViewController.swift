//
//  Scene+ViewController.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit

/// Separating out the user interface section from scene
extension Scene {
  func viewController() -> UIViewController {
    switch self {
    case .expenses(let viewModel):
      let navigationController = UIStoryboard(name: "Transactions", bundle: nil).instantiateViewController(withIdentifier: "TransactionsNavigationController") as! UINavigationController
      var viewController = navigationController.viewControllers.first! as! TransactionsViewController
      viewController.bind(viewModel: viewModel)
      return navigationController
    case .editExpense(let viewModel):
      let navigationController = UIStoryboard(name: "EditExpense", bundle: nil).instantiateViewController(withIdentifier: "EditExpenseNavigationController") as! UINavigationController
      var viewController = navigationController.viewControllers.first! as! EditExpenseViewController
      viewController.bind(viewModel: viewModel)
      return navigationController
    case .overview(let viewModel):
      let navigationController = UIStoryboard(name: "Overview", bundle: nil).instantiateViewController(withIdentifier: "OverviewNavigationController") as! UINavigationController
      var viewController = navigationController.viewControllers.first! as! OverviewViewController
      viewController.bind(viewModel: viewModel)
      return navigationController
    }
  }
}
