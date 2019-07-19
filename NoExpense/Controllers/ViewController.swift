//
//  ViewController.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var dropNavigationBarShadow = true {
    didSet {
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.layer.masksToBounds = false
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      navigationController?.navigationBar.layer.shadowColor = dropNavigationBarShadow ? UIColor.lightGray.cgColor : UIColor.clear.cgColor
      navigationController?.navigationBar.layer.shadowOpacity = dropNavigationBarShadow ? 0.5 : 0
      navigationController?.navigationBar.layer.shadowOffset = dropNavigationBarShadow ? CGSize(width: 0, height: 2.0) : CGSize(width: 0, height: 0)
      navigationController?.navigationBar.layer.shadowRadius = dropNavigationBarShadow ? 2 : 0
    }
  }
  
  var dropTabBarShadow = true {
    didSet {
      tabBarController?.tabBar.layer.masksToBounds = false
      tabBarController?.tabBar.layer.shadowColor = dropTabBarShadow ? UIColor.lightGray.cgColor : UIColor.clear.cgColor
      tabBarController?.tabBar.layer.shadowOpacity = dropTabBarShadow ? 0.5 : 0
      tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
      tabBarController?.tabBar.layer.shadowRadius = dropTabBarShadow ? 2 : 0
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    dropNavigationBarShadow = true
    dropTabBarShadow = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setNeedsStatusBarAppearanceUpdate()
  }
  
  override var prefersStatusBarHidden: Bool {
    return UIApplication.shared.statusBarOrientation.isLandscape
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
