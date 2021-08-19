//
//  ApiService.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation
import Moya
import RxSwift

class ApiService {
    
    private let authPlugin = AccessTokenPlugin { _ in
        SharedEngine.shared.getAccessToken()
    }
    private lazy var provider = MoyaProvider<ApiTarget>(
        plugins: [authPlugin]
    )
    static let shared: ApiService = ApiService()
    
    private init() {}
}

extension ApiService {
    
    func apiCall<T: Decodable>(type: T.Type, target: ApiTarget) -> Single<T> {
        return Single<T>.create { [provider] (single) -> Disposable in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let value = try response.map(T.self)
                        single(.success(value))
                    }  catch(let error) {
                        single(.failure(error))
                        print("Invalid JSON \(error)")
                    }
                case .failure:
                    single(.failure(NSError(domain: "Api Error", code: 402, userInfo: nil)))
                    print("Api Error")
                }
            }
            return Disposables.create()
        }
    }
}
