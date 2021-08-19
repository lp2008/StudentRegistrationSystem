//
//  ManageUserCoordinator.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import RxSwift

class ManageUserCoordinator: BaseCoordinator {
    
    private let router: RouterProtocol
    private let disposeBag = DisposeBag()
    private let user: User?
    
    init(router: RouterProtocol, user: User?) {
        self.router = router
        self.user = user
    }
    
    override func start() {
        let vc = EditUserViewController()
        vc.viewModelBuilder = {
            let viewModel = EditUserViewModel(input: $0, apiService: ApiService.shared, user: self.user)
            return viewModel
        }
        router.push(vc, isAnimated: true, onNavigationBack: isCompleted)
    }
}
