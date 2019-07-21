//
//  UIView+Extensions.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 21/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit

extension UIView {
  func roundCorners(borderWidth: CGFloat = 0, borderColor: UIColor = .clear, withRadius radius: CGFloat? = nil) {
    self.clipsToBounds = true
    self.layer.cornerRadius = radius ?? (self.frame.width > self.frame.height ? self.frame.height : self.frame.width)/2
    self.layer.borderWidth = borderWidth
    self.layer.borderColor = borderColor.cgColor
    self.layer.masksToBounds = true
  }
}
