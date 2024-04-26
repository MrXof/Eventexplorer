//
//  MapModule.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 22.04.2024.
//

import Foundation

class MapModule {
  
  @Published var pinTableArray = [AirtableRecord<Pin>]()
  
  private func getPinData() {
    NetworkManager.shared.getPinTableData { response in
      switch response {
      case .success(let pinTable):
        DispatchQueue.main.async {
          self.pinTableArray.append(contentsOf: pinTable.records)
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
