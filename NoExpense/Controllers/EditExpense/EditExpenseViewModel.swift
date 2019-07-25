//
//  EditExpenseViewModel.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCocoa

class EditExpenseViewModel {
  let transaction: TransactionItem
  let onUpdate: Action<UpdateInfo, Void>!
  let onCancel: CocoaAction?
  let disposeBag = DisposeBag()
  let categories = Observable.just(CategoryType.stringValues)
  
  let transactionService: TransactionServiceType
  var selectedImage = BehaviorRelay<UIImage?>(value: nil)
  let imagePathSubject = PublishSubject<String>()

  var hasImage: Observable<Bool> {
    return Observable.combineLatest(imagePathSubject.asObservable(), selectedImage.asObservable()) { $0.isEmpty && $1 == nil }
  }
  
  typealias Inputs = (Signal<Void>)
  typealias UploadImageWireframe  = (UploadImageServiceType)
  
  init(transaction: TransactionItem, service transactionService: TransactionServiceType, coordinator: SceneCoordinatorType, updateAction: Action<UpdateInfo, Void>, cancelAction: CocoaAction? = nil) {
    self.transaction = transaction
    self.transactionService = transactionService
    
    onUpdate = updateAction
    
    onUpdate.executionObservables
      .take(1)
      .subscribe { _ in
        coordinator.pop()
      }
      .disposed(by: disposeBag)
    
    onCancel = CocoaAction {
      if let cancelAction =  cancelAction {
        cancelAction.execute()
      }
      return coordinator.pop()
        .asObservable()
        .map { _ in }
    }
  }
  
  func set(inputs: Inputs, remove: Inputs, wireframe: UploadImageWireframe, popOverView: UIView) {
    selectedImage = wireframe.selectedImage
    
    selectedImage.subscribe(onNext: { [weak self] image in
      if let path = image?.save(), let transaction = self?.transaction {
        self?.transactionService.update(transcation: transaction, imagePath: path)
      }
    })
      .disposed(by: disposeBag)
    
    inputs.emit(onNext: { _ in
      var actions = [ActionSheetItem<UIImagePickerController.SourceType>]()
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        actions.insert(ActionSheetItem<UIImagePickerController.SourceType>(title: "TakeAPhoto".localized, selectType: .camera, style: .default), at: 0)
      }
      if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        actions.insert(ActionSheetItem<UIImagePickerController.SourceType>(title: "ChooseFromGallery".localized, selectType: .photoLibrary, style: .default), at: 0)
      }
      wireframe.showActionSheet(title: "", message: "", actions: actions, withPopoverView: popOverView)
    })
      .disposed(by: disposeBag)
    
    remove.emit(onNext: { [weak self] _ in
      if let transaction = self?.transaction {
        self?.transactionService.update(transcation: transaction, imagePath: "")
        self?.imagePathSubject.onNext("")
        self?.selectedImage.accept(nil)
      }
    })
      .disposed(by: disposeBag)
  }
}
