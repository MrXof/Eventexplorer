//
//  NetworkManager.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 15.04.2024.
//

import Foundation

enum DataError: Error {
  case invalidData
  case invalidResponse
  case message(_ error: Error?)
}

final class NetworkManager {
  static let shared = NetworkManager()
  private init() {}
  
  let url = URL(string: "https://api.airtable.com/v0/appbkJ66NrzqsAF8p/pins?maxRecords=3&view=Grid%20view")!
  
  func fetchData(completion: @escaping (Result<PinTable, Error>) -> Void) {
    var URLRequest = URLRequest(url: url)
    URLRequest.setValue("Bearer patrin0ge3TdKJSyO.4ab6bff6c550d0c69e4a88879811c62c095c5dba213340029ebca579008e03bc", forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: URLRequest) { data, response , error in
      guard let data else {
        completion(.failure(DataError.invalidData))
        return
      }
      print(data)
      guard let response = response as? HTTPURLResponse, 200 ... 200 ~= response.statusCode else {
        return
      }
      print(response)
      do {
        let products = try JSONDecoder().decode(PinTable.self, from: data)
        completion(.success(products))
        
      }
      catch {
        completion(.failure(DataError.message(error)))
      }
    }.resume()
  }
  
}

