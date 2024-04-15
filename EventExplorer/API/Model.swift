//
//  Model.swift
//  EventExplorer
//
//  Created by Даниил Чугуевский on 15.04.2024.
//

import Foundation

// MARK: - PinTable
struct PinTable: Codable {
  let records: [Position]
}

// MARK: - Record
struct Position: Codable {
  let id, createdTime: String
  let fields: Place
}

// MARK: - Place
struct Place: Codable {
  let priceTier, date, address, name: String
  let location, icon, category: String
  let usersGoing: Int
  let friendAvatars: [FriendAvatar]?
  let friendsAreGoing: Bool?
  
  enum CodingKeys: String, CodingKey {
    case priceTier = "price_tier"
    case date, address, name, location, icon, category
    case usersGoing = "users_going"
    case friendAvatars = "friend_avatars"
    case friendsAreGoing = "friends_are_going"
  }
}

// MARK: - FriendAvatar
struct FriendAvatar: Codable {
  let id: String
  let width, height: Int
  let url: String
  let filename: String
  let size: Int
  let type: String
}


