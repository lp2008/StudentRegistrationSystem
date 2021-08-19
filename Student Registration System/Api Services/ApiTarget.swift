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
    case deleteUser(params: [String: Any])
    case getUserList
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
        case .deleteUser:
            return "/users/deleteUser"
        case .getUserList:
            return "/users/getUserList"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .changePassword:
            return .put
        case .deleteUser:
            return .delete
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login(let params), .changePassword(let params), .deleteUser(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getUserList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

extension ApiTarget: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .changePassword, .deleteUser, .getUserList:
            return .bearer
        default:
            return .none
        }
    }
}
