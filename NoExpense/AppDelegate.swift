//
//  AppDelegate.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    realmMigration()
    debugLog("🔥", NSHomeDirectory().appending("/Documents/"))
    RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }
    let service = TransactionService()
    let sceneCoordinator = SceneCoordinator(window: window!)
    let transactionsViewModel = TransactionsViewModel(transactionService: service, coordinator: sceneCoordinator)
    let firstScene = Scene.expenses(transactionsViewModel)
    sceneCoordinator.transition(to: firstScene, type: .root)
    return true
  }
}
