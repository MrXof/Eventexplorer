//
//  PinAnnotationView.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 24.04.2024.
//

import Foundation
import UIKit
import MapKit
import SDWebImage

class PinAnnotationView: MKAnnotationView {
  
  @IBOutlet weak var labelIcon: UILabel!
  @IBOutlet weak var elipseView: UIView!
  @IBOutlet weak var labelUsersGoing: UILabel!
  
  var shapeLayer = CAShapeLayer()

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
    elipseView.isHidden = true
  }
  
  func display(_ annotation: MKAnnotation) {
    guard let customAnnotation = annotation as? PinAnnotation,
          let friendsIcon = customAnnotation.icon else { return }
    
    labelUsersGoing.text = "\(customAnnotation.usersGoing)"
    labelIcon.text = friendsIcon
    self.annotation = customAnnotation
    
    let annotationViewHeight = frame.height
    centerOffset = CGPoint(x: 0.0, y: -annotationViewHeight/2)
  }
  
  private func nibInstantiate(autoResizingMask: UIView.AutoresizingMask = []) -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
    let view = nib?.first as! UIView
    view.autoresizingMask = autoResizingMask
    return view
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    elipseView.isHidden = !selected
    
  }
  
}

