//
//  Show.swift
//  Test2
//
//  Created by The App Experts on 11/09/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation

struct Show: Codable {
  let name: String
  let image_thumbnail_path: URL
  let start_date: String?
  let end_date: String?
}
