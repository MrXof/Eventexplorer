//
//  MapModule.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 22.04.2024.
//

import Foundation

class MapModule {
  
  @Published var pinArray = [AirtableRecord<Pin>]()
  
  private func getPinData() {
    NetworkManager.shared.getPinData { response in
      switch response {
      case .success(let pinTable):
        DispatchQueue.main.async {
          self.pinArray.append(contentsOf: pinTable.records)
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  init() {
    self.getPinData()
  }
  
}
