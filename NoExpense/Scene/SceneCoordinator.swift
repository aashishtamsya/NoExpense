//
//  SceneCoordinator.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
  private var window: UIWindow
  private var currentViewController: UIViewController
  
  required init(window: UIWindow) {
    self.window = window
    currentViewController = window.rootViewController!
  }
  
  static func actualViewController(for viewController: UIViewController) -> UIViewController {
    guard let navigationController = viewController as? UINavigationController else {
      return viewController
    }
    return navigationController.viewControllers.first!
  }
  
  @discardableResult
  func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
    let subject = PublishSubject<Void>()
    let viewController = scene.viewController()
    switch type {
    case .root:
      currentViewController = SceneCoordinator.actualViewController(for: viewController)
      window.rootViewController = viewController
      subject.onCompleted()
    case .push:
      guard let navigationController = currentViewController.navigationController else {
        fatalError("Cannot push a view controller without base navigation controller")
      }
      _ = navigationController.rx.delegate
        .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
        .map { _ in }
        .bind(to: subject)
      navigationController.pushViewController(viewController, animated: true)
      currentViewController = SceneCoordinator.actualViewController(for: viewController)
    case .modal:
      currentViewController.present(viewController, animated: true) {
        subject.onCompleted()
      }
      currentViewController = SceneCoordinator.actualViewController(for: viewController)
    }
    return subject.asObservable()
      .take(1)
      .ignoreElements()
  }
  
  @discardableResult
  func pop(animated: Bool) -> Completable {
    let subject = PublishSubject<Void>()
    if let presenter = currentViewController.presentingViewController { // modal present
      currentViewController.dismiss(animated: animated) {
        self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
        subject.onCompleted()
      }
    } else if let navigationController = currentViewController.navigationController {
      _ = navigationController.rx.delegate
        .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
        .map { _ in }
        .bind(to: subject)
      guard navigationController.popViewController(animated: animated) != nil else {
        fatalError("cannot navigate back from \(currentViewController)")
      }
      currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
    } else {
      fatalError("Neither modally presented, nor navigational push. Cannot navigate back from \(currentViewController)")
    }
    return subject.asObservable()
      .take(1)
      .ignoreElements()
  }
}

