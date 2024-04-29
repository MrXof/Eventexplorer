//
//  PinAnnotation.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 22.04.2024.
//

import Foundation
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
  
  let coordinate: CLLocationCoordinate2D
  let image: String?
  let icon: String?
  let usersGoing: Int
  let friendsAreGoing: Bool
  let name: String
  let adress: String
  let category: String
  let date: String
  let priceTier: PriceTier

  init(latitude: Double,
       lontitude: Double,
       image: String?,
       icon: String?,
       usersGoing: Int,
       friendsAreGoing: Bool,
       name: String,
       adress: String,
       category: String,
       date: String,
       priceTier: PriceTier) {
    self.coordinate = CLLocationCoordinate2DMake(latitude, lontitude)
    self.image = image
    self.icon = icon
    self.usersGoing = usersGoing
    self.friendsAreGoing = friendsAreGoing
    self.name = name
    self.adress = adress
    self.category = category
    self.date = date
    self.priceTier = priceTier
  }
  
}
