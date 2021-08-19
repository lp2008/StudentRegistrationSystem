//
//  AppCoordinator.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        
        let router = Router(navigationController: self.navigationController)
        let onboardingCoordinator = LoginCoordinator(router: router)
        self.add(coordinator: onboardingCoordinator)
        onboardingCoordinator.isCompleted = { [weak self] in
            self?.remove(coordinator: onboardingCoordinator)
        }
        onboardingCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
