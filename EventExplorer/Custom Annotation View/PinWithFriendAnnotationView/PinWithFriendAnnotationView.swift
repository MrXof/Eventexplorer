//
//  PinWithFriendAnnotationView.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 23.04.2024.
//

import Foundation
import UIKit
import MapKit
import SDWebImage

class PinWithFriendAnnotationView: MKAnnotationView {
  
  @IBOutlet weak var pinImage: UIImageView!
  @IBOutlet weak var labelFriendsIcon: UILabel!
  
  private let shapeLayer = CAShapeLayer()
  
  override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("")
  }
  
  private func setup() {
    let view = self.nibInstantiate(autoResizingMask: [.flexibleHeight, .flexibleWidth])
    self.frame = view.frame
    addSubview(view)
    
    let annotationViewHeight = view.frame.height
    centerOffset = CGPoint(x: 0.0, y: -annotationViewHeight/2)
  }
  
  func display(_ annotation: MKAnnotation) {
    guard let customAnnotation = annotation as? PinAnnotation,
          let friendsIcon = customAnnotation.icon,
          let urlString = customAnnotation.image,
          let friendAvatarURL = URL(string: urlString) else { return }
    
    pinImage.sd_setImage(with: friendAvatarURL)
    
    labelFriendsIcon.text = friendsIcon
    self.annotation = customAnnotation
    
    let annotationViewHeight = frame.height
    centerOffset = CGPoint(x: 0.0, y: -annotationViewHeight/2)
    
  }
  
}

private extension PinWithFriendAnnotationView {
  
  func nibInstantiate(autoResizingMask: UIView.AutoresizingMask = []) -> UIView {
    let bundle = Bundle(for: Self.self)
    let nib = bundle.loadNibNamed(String(describing: Self.self), owner: self, options: nil)
    let view = nib?.first as! UIView
    view.autoresizingMask = autoResizingMask
    return view
  }
  
}
