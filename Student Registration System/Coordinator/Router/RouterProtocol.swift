//
//  RouterProtocol.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation

typealias NavigationBackClosure = (() -> ())

protocol RouterProtocol {
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigationBack closure: NavigationBackClosure?)
    func pop(_ isAnimated: Bool)
    func popToRoot(_ isAnimated: Bool)
    func present(_  drawable: Drawable, isAnimated: Bool, onDismiss: NavigationBackClosure?)
    func dismiss(_ isAnimated: Bool)
}

