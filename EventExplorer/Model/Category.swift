//
//  Category.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 10.04.2024.
//

import Foundation

enum Category: Equatable {
  
  case allActivities
  case education
  case culture
  case entertainment
  case sport
  case shopping
  case foodAndDrink
  case healthAndWellness
  
  var image: String? {
    switch self {
    case .allActivities:
      return nil
    case .education:
      return "🎓"
    case .culture:
      return "🎭"
    case .entertainment:
      return "💸"
    case .sport:
      return "🏋️"
    case .shopping:
      return "🛍"
    case .foodAndDrink:
      return "🍔"
    case .healthAndWellness:
      return "🏥"
    }
  }
  
  var name: String {
    switch self {
    case .allActivities:
      return "All activities"
    case .education:
      return "Education"
    case .culture:
      return "Culture"
    case .entertainment:
      return "Entertainment"
    case .sport:
      return "Sport"
    case .shopping:
      return "Shopping"
    case .foodAndDrink:
      return "Food & Drink"
    case .healthAndWellness:
      return "Health & Wellness"
    }
  }
  
}
