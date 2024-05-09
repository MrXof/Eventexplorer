//
//  ObjectStore.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 10.04.2024.
//

import Foundation

final class ObjectStore {
  
  let arrayCategories: [Category] = [
    Category.allActivities,
    Category.education,
    Category.culture,
    Category.entertainment,
    Category.sport,
    Category.shopping,
    Category.foodAndDrink,
    Category.healthAndWellness]
  
  static let shared = ObjectStore()
  private init() {}
  
}


