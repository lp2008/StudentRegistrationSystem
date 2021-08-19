//
//  ApiTarget.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Moya
import Foundation

enum ApiTarget {
    case login(params: [String: Any])
    case changePassword(params: [String: Any])
}

extension ApiTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: AppConstants.BASE_URL + AppConstants.API_VERSION)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/signin"
        case .changePassword:
            return "/users/changePassword"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .changePassword:
            return .put
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login(let params), .changePassword(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

extension ApiTarget: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .changePassword:
            return .bearer
        default:
            return .none
        }
    }
}
