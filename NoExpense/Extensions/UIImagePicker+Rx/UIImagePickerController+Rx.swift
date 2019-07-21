//
//  UIImagePickerController+Rx.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 21/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIImagePickerController {
  public var didFinishPickingMediaWithInfo: Observable<[String: AnyObject]> {
    return delegate
      .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
      .map({ (a) in
        return try castOrThrow(Dictionary<String, AnyObject>.self, a[1])
      })
  }
  
  public var didCancel: Observable<()> {
    return delegate
      .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
      .map {_ in () }
  }
}

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
  guard let returnValue = object as? T else {
    throw RxCocoaError.castingError(object: object, targetType: resultType)
  }
  return returnValue
}
