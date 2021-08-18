//
//  Drawable.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension  UIViewController: Drawable {
    var viewController: UIViewController? { return self }
}
