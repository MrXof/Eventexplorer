//
//  CACornerMask+corners.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 13.05.2024.
//

import QuartzCore

extension CACornerMask {
  
  static var topCorners: CACornerMask {
    return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  static var downCorners: CACornerMask {
    return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
  }
  static var allCorners: CACornerMask {
    return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
  }
  
}
