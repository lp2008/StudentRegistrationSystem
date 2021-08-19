//
//  UserListCoordinator.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import RxSwift

class UserListCoordinator: BaseCoordinator {
    
    private let router: RouterProtocol
    private let disposeBag = DisposeBag()
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    override func start() {
        let vc = ManageUserViewController()
        vc.viewModelBuilder = {
            let viewModel = UserListViewModel(input: $0, apiService: ApiService.shared)
            viewModel.openManageUser = { [weak self] user in
                self?.openManageUserVC(user: user)
            }
            return viewModel
        }
        router.push(vc, isAnimated: true, onNavigationBack: isCompleted)
    }
}

private extension UserListCoordinator {
    
    func openManageUserVC(user: User?) {
        let coordinator = ManageUserCoordinator(router: router, user: user)
        self.add(coordinator: coordinator)
        coordinator.isCompleted = { [weak self] in
            self?.remove(coordinator: coordinator)
        }
        coordinator.start()
    }
}
