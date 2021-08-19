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
            viewModel.loginSuccess = {
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
