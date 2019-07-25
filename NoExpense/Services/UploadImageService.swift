//
//  UploadImageService.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 21/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UploadImageService: UploadImageServiceType {
  
  var viewController: UIViewController? { return sampleViewController }
  private weak var sampleViewController: EditExpenseViewController?
  
  private let disposeBag = DisposeBag()
  
  let selectedImage: BehaviorRelay<UIImage?>
  
  init(view: EditExpenseViewController) {
    self.sampleViewController = view
    self.selectedImage = BehaviorRelay<UIImage?>(value: nil)
  }
  
  func showActionSheet<T>(title: String, message: String, actions: [ActionSheetItem<T>], withPopoverView popoverView: UIView) {
    viewController?.showActionSheet(title: title, message: message, actions: actions, withPopoverView: popoverView)
      .subscribe({ [unowned self] event in
        if let sourceType = event.element as? UIImagePickerController.SourceType {
          switch sourceType {
          case .camera:
            self.launchPhotoPicker(.camera)
          case .photoLibrary:
            self.launchPhotoPicker(.photoLibrary)
          case .savedPhotosAlbum:
            break
          @unknown default:
            break
          }
        }
      })
      .disposed(by: self.disposeBag)
  }
  
  private func launchPhotoPicker(_ type: UIImagePickerController.SourceType) {
    UIImagePickerController.rx.createWithParent(self.viewController) { picker in
      picker.sourceType = type
      picker.allowsEditing = true
      }
      .flatMap { $0.rx.didFinishPickingMediaWithInfo }
      .take(1)
      .map { info in return info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage }
      .bind(to: self.selectedImage)
      .disposed(by: self.disposeBag)
  }
}
