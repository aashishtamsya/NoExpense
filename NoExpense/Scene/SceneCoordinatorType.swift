//
//  SceneCoordinatorType.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import RxSwift

protocol SceneCoordinatorType {
  @discardableResult
  func transition(to scene: Scene, type: SceneTransitionType) -> Completable
  
  @discardableResult
  func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
  @discardableResult
  func pop() -> Completable {
    return pop(animated: true)
  }
}
