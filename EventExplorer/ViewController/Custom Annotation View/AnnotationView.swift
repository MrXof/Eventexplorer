//
//  AnnotationView.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 23.04.2024.
//

import Foundation
import UIKit

class AnnotationView: UIView {
  
  private var rectangleView: UIView!
  private var annotation: CustomAnnotation?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    drawTriangle()
    addRectangleView()
    addImageToRectangle()
  }
  
  func drawTriangle() {
    
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 24.665, y: 62))
    path.addLine(to: CGPoint(x: 32, y: 74.06))
    path.addLine(to: CGPoint(x: 39.335, y: 62))
    path.addLine(to: CGPoint(x: 24.665, y: 62))
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.strokeColor = UIColor.white.cgColor
    shapeLayer.fillColor = UIColor.white.cgColor
    
    layer.addSublayer(shapeLayer)
  }
  
  func addRectangleView() {
    
    rectangleView = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    rectangleView.backgroundColor = UIColor.white
    rectangleView.layer.cornerRadius = 32
    
    addSubview(rectangleView)
    bringSubviewToFront(rectangleView)
  }
  
  func addImageToRectangle() {
    let imageView = UIImageView(frame: CGRect(x: 4, y: 4, width: 56, height: 56))
    guard let annotationImage = annotation?.image else { return }
            
    imageView.image = UIImage(named: annotationImage)
    
    imageView.layer.cornerRadius = 28
    imageView.layer.masksToBounds = true
    rectangleView.addSubview(imageView)
  }
  
  func cconfigure(with annotation: CustomAnnotation) {
    self.annotation = annotation
  }
  
}
