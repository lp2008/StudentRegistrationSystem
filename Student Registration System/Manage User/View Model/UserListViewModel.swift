//
//  UserListViewModel.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol UserListViewPresentable {
    
    typealias Input = (
        (),
        ()
    )
    typealias Output = (
        users: Driver<[User]>,
        ()
    )
    typealias ViewModelBuilder = (UserListViewPresentable.Input) -> UserListViewPresentable
    
    var input: UserListViewPresentable.Input { get }
    var output: UserListViewPresentable.Output { get }
    
    var clickUser: ((_ position: Int) -> Void)? { get }
}

class UserListViewModel: UserListViewPresentable {
    
    var input: UserListViewPresentable.Input
    var output: UserListViewPresentable.Output
    
    var clickUser: ((_ position: Int) -> Void)?
    var openManageUser: ((_ user: User?) -> Void)?
    
    typealias State = (
        users: BehaviorRelay<[User]>,
        ()
    )
    private let state: State = (
        users: BehaviorRelay<[User]>(value: []),
        ()
    )
    
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    
    init(input: UserListViewPresentable.Input, apiService: ApiService) {
        self.input = input
        self.apiService = apiService
        self.output = UserListViewModel.output(state: self.state)
        self.process()
        self.clickUser = { [weak self] position in
            self?.openManageUser?(self?.state.users.value[position])
        }
    }
}

private extension UserListViewModel {
    
    static func output(state: State) -> UserListViewPresentable.Output {
        
        let users = state.users
            .asObservable()
            .asDriver(onErrorJustReturn: [])
        
        return (users: users, ())
    }
    
    func process() {
        
        Utils.sharedManager.showActivity()
        
        self.apiService
            .apiCall(type: UserResponse.self, target: .getUserList)
            .map({
                self.state.users.accept($0.data?.users ?? [])
                Utils.sharedManager.hideActivity()
            })
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
