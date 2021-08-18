//
//  Router.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit

final class Router: NSObject {
    
    private let navigationController: UINavigationController
    private var closures: [String: NavigationBackClosure] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
}

extension Router: RouterProtocol {
    
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigationBack closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else { return }
        
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func pop(_ isAnimated: Bool) {
        self.navigationController.popViewController(animated: true)
    }
    
    func popToRoot(_ isAnimated: Bool) {
        self.navigationController.popToRootViewController(animated: true)
    }
    
    func present(_ drawable: Drawable, isAnimated: Bool, onDismiss: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else { return }
        
        if let closure = onDismiss {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        navigationController.present(viewController, animated: isAnimated, completion: nil)
        viewController.presentationController?.delegate = self
    }
    
    func dismiss(_ isAnimated: Bool) {
        self.navigationController.dismiss(animated: true, completion: nil)
    }
    
    func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else {
            return
        }
        closure()
    }
}

extension Router: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        executeClosure(presentationController.presentedViewController)
    }
}

extension Router: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let previousViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        guard !navigationController.viewControllers.contains(previousViewController) else {
            return
        }
        
        executeClosure(previousViewController)
    }
}
