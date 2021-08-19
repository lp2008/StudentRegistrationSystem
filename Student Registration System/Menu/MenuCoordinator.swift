//
//  MenuCoordinator.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import RxSwift

class MenuCoordinator: BaseCoordinator {
    
    private let router: RouterProtocol
    private let disposeBag = DisposeBag()
    private let role: String
    
    init(router: RouterProtocol, role: String) {
        self.router = router
        self.role = role
    }
    
    override func start() {
        let vc = MenuViewController()
        vc.viewModelBuilder = {
            let viewModel = MenuViewModel(input: $0, dependencies: (role: self.role, ()))
            return viewModel
        }
        router.push(vc, isAnimated: true, onNavigationBack: isCompleted)
    }
}
