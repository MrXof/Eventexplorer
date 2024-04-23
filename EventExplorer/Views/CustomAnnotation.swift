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

  init(latitude: Double, lontitude: Double) {
    self.coordinate = CLLocationCoordinate2DMake(latitude, lontitude)
  }
  
}
