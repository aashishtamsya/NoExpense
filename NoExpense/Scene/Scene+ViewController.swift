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
    case .expenses, .editExpense:
      let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
      return viewController
    }
  }
}
