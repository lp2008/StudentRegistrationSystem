//
//  User.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation

struct LoginResponse: Decodable {
    let status: Bool?
    let message: String?
    let token: String?
    let data: LoginData?
}

struct LoginData: Decodable {
    let user: User?
}

struct User: Decodable {
    let id: Int?
    let name: String?
    let role: String?
    let email: String?
}

struct Valid {
    var isValid = false
    var message = ""
}
