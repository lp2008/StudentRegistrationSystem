//
//  ServerResponse.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation

struct ServerResponse: Decodable {
    let status: Bool?
    let message: String?
}
