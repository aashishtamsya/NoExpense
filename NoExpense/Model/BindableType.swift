//
//  BindableType.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation
import RxSwift

protocol BindableType {
  associatedtype ViewModelType
  
  var viewModel: ViewModelType! { get set }
  
  func bindViewModel()
}

extension BindableType where Self: ViewController {
  mutating func bindViewModel(to model: Self.ViewModelType) {
    viewModel = model
    loadViewIfNeeded()
    bindViewModel() // ensures viewmodel is set once the view has loaded.
  }
}
