//
//  UIImage+Extensions.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 21/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit

extension UIImage {
  private static var documentsUrl: URL? {
    guard let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
    return url
  }
  
  func save() -> String? {
    let fileName = "\(Int(Date().timeIntervalSince1970)).jpeg"
    guard let fileURL = UIImage.documentsUrl?.appendingPathComponent(fileName, isDirectory: true) else { return nil }
    if let imageData = jpegData(compressionQuality: 1.0) {
      try? imageData.write(to: fileURL, options: .atomic)
      return fileName
    }
    return nil
  }
  
  static func load(fileName: String) -> UIImage? {
    guard !fileName.isEmpty, let fileURL = documentsUrl?.appendingPathComponent(fileName) else { return nil }
    do {
      let imageData = try Data(contentsOf: fileURL)
      return UIImage(data: imageData)
    } catch {
      print("Error loading image : \(error)")
    }
    return nil
  }
  
}
