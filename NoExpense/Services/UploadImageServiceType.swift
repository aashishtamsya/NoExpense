//
//  SampleWireframeType.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 21/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol UploadImageServiceType {
  func showActionSheet<T>(title: String, message: String, actions: [ActionSheetItem<T>])
  var selectedImage: BehaviorRelay<UIImage?> { get }
}
