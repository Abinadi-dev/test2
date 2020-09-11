//
//  ShowSprite.swift
//  Test2
//
//  Created by The App Experts on 11/09/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation

struct ShowSprite: Decodable {
  let spriteURL: URL
  
  enum CodingKeys: String, CodingKey {
    case sprites
  }
  
  enum SpriteContainerCodingKeys: String, CodingKey {
    case frontImageURL = "front_default"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let spriteContainer = try container.nestedContainer(keyedBy: SpriteContainerCodingKeys.self, forKey: .sprites)
    self.spriteURL = try spriteContainer.decode(URL.self, forKey: .frontImageURL)
  }
}
