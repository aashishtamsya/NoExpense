//
//  RxImagePickerDelegateProxy.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 21/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class RxImagePickerDelegateProxy: RxNavigationControllerDelegateProxy, UIImagePickerControllerDelegate {
  public init(imagePicker: UIImagePickerController) {
    super.init(navigationController: imagePicker)
  }
}
