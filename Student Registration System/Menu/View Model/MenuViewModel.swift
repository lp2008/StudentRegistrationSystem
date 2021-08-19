//
//  MenuViewModel.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol MenuViewPresentable {
    
    typealias Input = (
        (),
        ()
    )
    typealias Output = (
        menuOptions: Driver<[String]>,
        ()
    )
    typealias ViewModelBuilder = (MenuViewPresentable.Input) -> MenuViewPresentable
    typealias Dependencies = (role: String, ())
    
    var input: MenuViewPresentable.Input { get }
    var output: MenuViewPresentable.Output { get }
    
    var onTapMenu: ((_ position: Int) -> Void)? { get }
    var onTapLogout: (() -> Void)? { get }
}

class MenuViewModel: MenuViewPresentable {
    
    var input: MenuViewPresentable.Input
    var output: MenuViewPresentable.Output
    
    var onTapMenu: ((_ position: Int) -> Void)?
    var onTapLogout: (() -> Void)?
    
    typealias State = (
        menuOptions: BehaviorRelay<[String]>,
        ()
    )
    private let state: State = (
        menuOptions: BehaviorRelay<[String]>(value: []),
        ()
    )
    
    private let disposeBag = DisposeBag()
    
    init(input: MenuViewPresentable.Input, dependencies: MenuViewPresentable.Dependencies) {
        self.input = input
        self.output = MenuViewModel.output(state: self.state)
        self.generateData(dependencies: dependencies)
    }
    
    func getMenuName(position: Int) -> String {
        return state.menuOptions.value[position]
    }
}

private extension MenuViewModel {
    
    static func output(state: State) -> MenuViewPresentable.Output {
        
        let menuOptions = state.menuOptions
            .asObservable()
            .asDriver(onErrorJustReturn: [])
        
        return (menuOptions: menuOptions, ())
    }
    
    func generateData(dependencies: MenuViewPresentable.Dependencies) {
        var menuModels: [String] = ["Change Password", "Edit Profile"]
        if dependencies.role == "Admin" {
            menuModels.append("Add Users")
            menuModels.append("Remove Users")
            menuModels.append("Manage Users")
        }
        state.menuOptions.accept(menuModels)
    }
}
