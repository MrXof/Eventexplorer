//
//  MapModule.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 22.04.2024.
//

import Foundation

class MapModule {
  
  @Published var pinArray = [AirtableRecord<Pin>]()
  var currentFilter = ObjectStore.shared.arrayCategories[0]
  var allPins = [AirtableRecord<Pin>]()
  
  private func getPinData() {
    NetworkManager.shared.getPinData { response in
      switch response {
      case .success(let pinTable):
        DispatchQueue.main.async {
          self.allPins.append(contentsOf: pinTable.records)
          self.updatePins()
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func applyCurrentFilter(_ filter: Category) {
    currentFilter = filter
    updatePins()
  }
  
  private func updatePins() {
    var pins = [AirtableRecord<Pin>]()
    for pin in allPins {
      if pin.fields.category == currentFilter {
        pins.append(pin)
      }
      
      if currentFilter == Category.allActivities {
        pins.append(pin)
      }
      
    }
    
    pinArray = pins
  }
  
  init() {
    self.getPinData()
  }
  
}
