//
//  UserResponse.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation

struct UserResponse: Decodable {
    let status: Bool?
    let results: Int?
    let message: String?
    let data: UserData?
}

struct UserData: Decodable {
    let users: [User]?
}
