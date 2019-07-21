//
//  Log+Extensions.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 21/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation

func debugLog(_ items: Any...) {
  #if DEBUG
  print(items)
  #endif
}
