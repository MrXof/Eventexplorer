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
  
  let url = URL(string: "https://api.airtable.com/v0/appbkJ66NrzqsAF8p/pins?&view=Grid%20view")!
  
  func getPinData(completion: @escaping (Result<AirtableResponse<Pin>, Error>) -> Void) {
    var URLRequest = URLRequest(url: url)
    URLRequest.setValue("Bearer patrin0ge3TdKJSyO.4ab6bff6c550d0c69e4a88879811c62c095c5dba213340029ebca579008e03bc", forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: URLRequest) { data, response , error in
      guard let data else {
        completion(.failure(DataError.invalidData))
        return
      }
      guard let response = response as? HTTPURLResponse, 200 ... 200 ~= response.statusCode else {
        completion(.failure(DataError.invalidResponse))
        return
      }
      
      do {
        let products = try JSONDecoder().decode(AirtableResponse<Pin>.self, from: data)
        completion(.success(products))
        
      }
      catch {
        completion(.failure(DataError.message(error)))
      }
    }.resume()
  }
  
}

