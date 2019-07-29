//
//  String+Extensions.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation

extension String {
  var localized: String { get { return NSLocalizedString(self, comment: "") } }
}
