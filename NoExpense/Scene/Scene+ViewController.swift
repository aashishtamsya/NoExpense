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
    case .expenses:
      let navigationController = UIStoryboard(name: "Transactions", bundle: nil).instantiateViewController(withIdentifier: "TransactionsNavigationController") as! UINavigationController
      let viewController = navigationController.viewControllers.first! as! TransactionsViewController
      return viewController
     case .editExpense:
      let navigationController = UIStoryboard(name: "EditExpense", bundle: nil).instantiateViewController(withIdentifier: "EditExpenseNavigationController") as! UINavigationController
      let viewController = navigationController.viewControllers.first! as! EditExpenseViewController
      return viewController
    }
  }
}
