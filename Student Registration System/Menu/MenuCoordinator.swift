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
            viewModel.onTapMenu = { [weak self] position in
                if position == 0 {
                    self?.openChangePassword()
                } else if position == 3 {
                    self?.openDeleteVC()
                } else if position == 1 {
                    self?.openEditProfileVC()
                } else if position == 2 {
                    self?.openAddUserVC()
                } else if position == 4 {
                    self?.openAllUserVC()
                }
            }
            viewModel.onTapLogout = {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate  else {
                    return
                  }
                AppCoordinator(window: sceneDelegate.window!).start()
            }
            return viewModel
        }
        router.push(vc, isAnimated: true, onNavigationBack: isCompleted)
    }
}

private extension MenuCoordinator {
    
    func openChangePassword() {
        let coordinator = ChangePasswordCoordinator(router: router)
        self.add(coordinator: coordinator)
        coordinator.isCompleted = { [weak self] in
            self?.remove(coordinator: coordinator)
        }
        coordinator.start()
    }
    
    func openDeleteVC() {
        let coordinator = DeleteUserCoordinator(router: router)
        self.add(coordinator: coordinator)
        coordinator.isCompleted = { [weak self] in
            self?.remove(coordinator: coordinator)
        }
        coordinator.start()
    }
    
    func openEditProfileVC() {
        let coordinator = EditProfileCoordinator(router: router)
        self.add(coordinator: coordinator)
        coordinator.isCompleted = { [weak self] in
            self?.remove(coordinator: coordinator)
        }
        coordinator.start()
    }
    
    func openAddUserVC() {
        let coordinator = AddUserCoordinator(router: router)
        self.add(coordinator: coordinator)
        coordinator.isCompleted = { [weak self] in
            self?.remove(coordinator: coordinator)
        }
        coordinator.start()
    }
    
    func openAllUserVC() {
        let coordinator = UserListCoordinator(router: router)
        self.add(coordinator: coordinator)
        coordinator.isCompleted = { [weak self] in
            self?.remove(coordinator: coordinator)
        }
        coordinator.start()
    }
}
