//
//  Utils.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation
import Kingfisher
import NVActivityIndicatorView

class Utils {
    
    static let sharedManager: Utils = Utils()
    
    private init() {}
    
    let modifier = AnyModifier { request in
        var r = request
        let token = SharedEngine.shared.getAccessToken()
        r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return r
    }
    
    func showActivity() {
        let activityData = ActivityData(size: nil, message: nil, messageFont: nil, messageSpacing: nil, type: .ballClipRotate, color: UIColor.blue, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        NVActivityIndicatorPresenter.sharedInstance.setMessage("")
    }
    
    func hideActivity() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}
