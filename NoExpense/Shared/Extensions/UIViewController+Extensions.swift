//
//  UIViewController+Extensions.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 21/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
  func showActionSheet<T>(title: String?, message: String?, cancelMessage: String = "Cancel".localized, actions: [ActionSheetItem<T>], withPopoverView view: Any) -> Observable<T> {
    let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    if let popoverPresentationController = actionSheet.popoverPresentationController {
      if let barButtonItem = view as? UIBarButtonItem {
        popoverPresentationController.barButtonItem = barButtonItem
      } else if let view = view as? UIView, UIDevice.current.userInterfaceIdiom == .pad {
        popoverPresentationController.sourceView = view
        popoverPresentationController.sourceRect = view.bounds
      }
    }
    return actionSheet.addAction(actions: actions, cancelMessage: cancelMessage, cancelAction: nil)
      .do(onSubscribed: { [weak self] in
        self?.present(actionSheet, animated: true, completion: nil)
      })
  }
}
