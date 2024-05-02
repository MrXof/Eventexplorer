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
  
  @IBOutlet private weak var triangleView: UIView!
  @IBOutlet private weak var labelIcon: UILabel!
  @IBOutlet private weak var labelUsersGoing: UILabel!
  @IBOutlet weak var rectangleView: UIView!
  
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
    
    drawTriangle(at: triangleView.frame.origin, with: triangleView.frame.size)
    triangleView.layer.bounds = shapeLayer.bounds
    createShadowView()
  }
  
  private func drawTriangle(at origin: CGPoint, with size: CGSize) {
    let trianglePath = UIBezierPath()
    trianglePath.move(to: CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height))
    trianglePath.addLine(to: CGPoint(x: origin.x, y: origin.y))
    trianglePath.addLine(to: CGPoint(x: origin.x + size.width, y: origin.y))
    trianglePath.close()
    
    shapeLayer.path = trianglePath.cgPath
    shapeLayer.strokeColor = UIColor.white.cgColor
    shapeLayer.fillColor = UIColor.white.cgColor
    
    layer.addSublayer(shapeLayer)
  }
  
  func display(_ annotation: MKAnnotation) {
    guard let customAnnotation = annotation as? PinAnnotation,
          let friendsIcon = customAnnotation.icon else { return }
    
    labelUsersGoing.text = "\(customAnnotation.usersGoing)"
    labelIcon.text = friendsIcon
    self.annotation = customAnnotation
  }
  
  private func nibInstantiate(autoResizingMask: UIView.AutoresizingMask = []) -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
    let view = nib?.first as! UIView
    view.autoresizingMask = autoResizingMask
    return view
  }
  
  func createShadowView(
    color: UIColor = .black,
    alpha: Float = 0.25,
    x: CGFloat = 0,
    y: CGFloat = 4,
    blur: CGFloat = 4,
    spread: CGFloat = 0
  )
  {
    triangleView.layer.shadowColor = color.cgColor
    triangleView.layer.shadowOpacity = alpha
    triangleView.layer.shadowOffset = CGSize(width: x, height: y)
    triangleView.layer.shadowRadius = blur
    triangleView.layer.shadowRadius += spread
    
    rectangleView.layer.shadowColor = color.cgColor
    rectangleView.layer.shadowOpacity = alpha
    rectangleView.layer.shadowOffset = CGSize(width: x, height: y)
    rectangleView.layer.shadowRadius = blur
    rectangleView.layer.shadowRadius += spread
  }
}

