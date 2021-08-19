//
//  LoginCoordinator.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import RxSwift

class LoginCoordinator: BaseCoordinator {
    
    private let router: RouterProtocol
    private let disposeBag = DisposeBag()
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    override func start() {
        let vc = LoginViewController()
        vc.viewModelBuilder = {
            let viewModel = LoginViewModel(input: $0, apiService: ApiService.shared)
            viewModel.loginSuccess = { role in
                self.openMenu(role: role)
            }
            return viewModel
        }
        router.push(vc, isAnimated: true, onNavigationBack: isCompleted)
    }
}

private extension LoginCoordinator {
    
    func openMenu(role: String) {
        let coordinator = MenuCoordinator(router: router, role: role)
        self.add(coordinator: coordinator)
        coordinator.isCompleted = { [weak self] in
            self?.remove(coordinator: coordinator)
        }
        coordinator.start()
    }
}
