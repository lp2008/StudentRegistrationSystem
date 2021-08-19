//
//  ChangePasswordCoordinator.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import RxSwift

class ChangePasswordCoordinator: BaseCoordinator {
    
    private let router: RouterProtocol
    private let disposeBag = DisposeBag()
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    override func start() {
        let vc = ChangePasswordViewController()
        vc.viewModelBuilder = {
            let viewModel = ChangePasswordViewModel(input: $0, apiService: ApiService.shared)
            return viewModel
        }
        router.push(vc, isAnimated: true, onNavigationBack: isCompleted)
    }
}
