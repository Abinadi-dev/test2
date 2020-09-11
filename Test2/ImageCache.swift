//
//  ImageCache.swift
//  Test2
//
//  Created by The App Experts on 11/09/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import UIKit

final class ImageCache {
  
  static let shared = ImageCache()
  
  private init() { }
  
  private let cache: NSCache<NSString, UIImage> = NSCache()
  
  func saveImage(with url: URL, image: UIImage) {
    self.cache.setObject(image, forKey: url.absoluteString as NSString)
  }
  
  func retrieveImage(with url: URL) -> UIImage? {
    return self.cache.object(forKey: url.absoluteString as NSString)
  }
}
