//
//  UIView+cornerRadius.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 13.05.2024.
//

import UIKit

extension UIView {
  
  func applyCornerRadius(radius: CGFloat, clipsToBounds: Bool = true, maskedCorners: CACornerMask = .allCorners) {
    layer.cornerRadius = radius
    layer.maskedCorners = maskedCorners
    self.clipsToBounds = clipsToBounds
  }
  
}
