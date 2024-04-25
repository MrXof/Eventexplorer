//
//  AnnotationView.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 23.04.2024.
//

import Foundation
import UIKit
import MapKit
import SDWebImage

class AnnotationView: MKAnnotationView {
  
  @IBOutlet weak var pinVIew: UIView!
  @IBOutlet weak var pinImage: UIImageView!
  @IBOutlet weak var triangleView: UIView!
  @IBOutlet weak var labelFriendsIcon: UILabel!
  @IBOutlet weak var friendsIconView: UIView!
  
  private var rectangleView: UIView!
  let imageView = UIImageView()
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
  }
  
  func drawTriangle(at origin: CGPoint, with size: CGSize) {
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
    guard let customAnnotation = annotation as? CustomAnnotation,
          let friendsIcon = customAnnotation.icon,
          let urlString = customAnnotation.image,
          let friendAvatarURL = URL(string: urlString) else { return }
    
    pinImage.sd_setImage(with: friendAvatarURL)
    friendsIconView.backgroundColor = UIColor.white
    
    labelFriendsIcon.text = friendsIcon
  }

}

private extension AnnotationView {
  func nibInstantiate(autoResizingMask: UIView.AutoresizingMask = []) -> UIView {
    let bundle = Bundle(for: Self.self)
    let nib = bundle.loadNibNamed(String(describing: Self.self), owner: self, options: nil)
    let view = nib?.first as! UIView
    view.autoresizingMask = autoResizingMask
    return view
  }
  
}
