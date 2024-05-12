//
//  Category.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 10.04.2024.
//

import Foundation

enum Category: String, Equatable, Decodable {
  
  case allActivities = "all_activities"
  case education
  case culture
  case entertainment
  case sport
  case shopping
  case foodAndDrink = "food_and_drink"
  case healthAndWellness = "health_and_wellness"
  
  var icon: String? {
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
      return NSLocalizedString("category.label.all_activities", comment: "")
    case .education:
      return NSLocalizedString("catgory.label.education", comment: "")
    case .culture:
      return NSLocalizedString("category.label.culture", comment: "")
    case .entertainment:
      return NSLocalizedString("category.label.entertainment", comment: "")
    case .sport:
      return NSLocalizedString("category.label.sport", comment: "")
    case .shopping:
      return NSLocalizedString("category.label.shopping", comment: "")
    case .foodAndDrink:
      return NSLocalizedString("category.label.food_and_drink", comment: "")
    case .healthAndWellness:
      return NSLocalizedString("category.label.health_and_wellness", comment: "")
    }
  }
  
}
