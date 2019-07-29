//
//  UIAlertController+Extensions.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 21/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct ActionSheetItem<Type> {
  let title: String
  let selectType: Type
  let style: UIAlertAction.Style
}

extension UIAlertController {
  func addAction<T>(actions: [ActionSheetItem<T>], cancelMessage: String, cancelAction: ((UIAlertAction) -> Void)?) -> Observable<T> {
    return Observable.create { [weak self] observer in
      actions.map { action in
        return UIAlertAction(title: action.title, style: action.style) { _ in
          observer.onNext(action.selectType)
          observer.onCompleted()
        }
        }.forEach { action in
          self?.addAction(action)
      }
      
      self?.addAction(UIAlertAction(title: cancelMessage, style: .cancel) {
        cancelAction?($0)
        observer.onCompleted()
      })
      
      return Disposables.create {
        self?.dismiss(animated: true, completion: nil)
      }
    }
  }
}
