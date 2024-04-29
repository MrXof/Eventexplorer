//
//  Model.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 15.04.2024.
//

import Foundation

// MARK: - AirtableResponse
struct AirtableResponse<T: Decodable>: Decodable {
  
  let records: [AirtableRecord<T>]
  // AirtableResponse<Pin>
  
}

// MARK: - AirtableRecord
struct AirtableRecord<T: Decodable>: Decodable {
  
  let id, createdTime: String
  let fields: T
  
}

// MARK: - Pin
struct Pin {
  
  let date, address, name: String
  let priceTier: PriceTier
  let icon, category: String
  let latitudeLocation, longitudeLocation: Double
  let usersGoing: Int
  let friendsAreGoing: Bool
  let friendAvatar: FriendAvatar?
  
  enum CodingKeys: String, CodingKey {
    
    case priceTier = "price_tier"
    case date, address, name, location, icon, category
    case usersGoing = "users_going"
    case friendAvatars = "friend_avatar"
    case friendsAreGoing = "friends_are_going"
    
  }
  
}

// MARK: - FriendAvatar
struct FriendAvatar: Decodable {
  
  let id: String
  let width, height: Int
  let url: String
  let filename: String
  let size: Int
  let type: String
  
}

enum PriceTier: String, Decodable {
  
  case below = "below_10"
  case tenPlus = "10_plus"
  case twentyPlus = "20_plus"
  case fiftyPlus = "50_plus"
  
  func stringValue() -> String {
    switch self {
    case .below:
      return "$10-"
    case .tenPlus:
      return "$10+"
    case .twentyPlus:
      return "$20+"
    case .fiftyPlus:
      return "$50+"
    }
  }
  
}

extension Pin: Decodable {
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let location = try container.decode(String.self, forKey: .location)
    date = try container.decode(String.self, forKey: .date)
    address = try container.decode(String.self, forKey: .address)
    name = try container.decode(String.self, forKey: .name)
    icon = try container.decode(String.self, forKey: .icon)
    category = try container.decode(String.self, forKey: .category)
    usersGoing = try container.decode(Int.self, forKey: .usersGoing)
    friendAvatar = try container.decodeIfPresent([FriendAvatar].self, forKey: .friendAvatars)?.first ??  nil
    priceTier = try container.decode(PriceTier.self, forKey: .priceTier)
    
    friendsAreGoing = (try? container.decode(Bool.self, forKey: .friendsAreGoing)) ?? false
    
    let locationArray = location.components(separatedBy: ", ")
    latitudeLocation = Double(locationArray[0])!
    longitudeLocation = Double(locationArray[1])!
  }
  
}
