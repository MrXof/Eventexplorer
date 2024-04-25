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
  var icon: String?
  var usersGoing: Int
  var friendsAreGoing: Bool
  weak var annotationView: AnnotationView?

  init(latitude: Double, lontitude: Double, title: String?, image: String?, icon: String?, usersGoing: Int, friendsAreGoing: Bool) {
    self.coordinate = CLLocationCoordinate2DMake(latitude, lontitude)
    self.title = title
    self.image = image
    self.icon = icon
    self.usersGoing = usersGoing
    self.friendsAreGoing = friendsAreGoing
  }
  
}
