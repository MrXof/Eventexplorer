//
//  CustomAnnotation.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 22.04.2024.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
  
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var image: String?
  weak var annotationView: AnnotationView?

  init(latitude: Double, lontitude: Double, title: String?, image: String?) {
    self.coordinate = CLLocationCoordinate2DMake(latitude, lontitude)
    self.title = title
    self.image = image
  }
  
  func updateAnnotationView() {
    guard let annotationView = annotationView else { return }
    
    annotationView.cconfigure(with: self)
  }
  
}
