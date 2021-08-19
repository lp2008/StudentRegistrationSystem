//
//  DeleteUserViewModel.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol DeleteUserViewPresentable {
    
    typealias Input = (
        (),
        ()
    )
    typealias Output = (
        users: Driver<[User]>,
        serverResponse: Driver<ServerResponse?>
    )
    typealias ViewModelBuilder = (DeleteUserViewPresentable.Input) -> DeleteUserViewPresentable
    
    var input: DeleteUserViewPresentable.Input { get }
    var output: DeleteUserViewPresentable.Output { get }
    
    var onTapDelete: ((_ position: Int) -> Void)? { get }
}

class DeleteUserViewModel: DeleteUserViewPresentable {
    
    var input: DeleteUserViewPresentable.Input
    var output: DeleteUserViewPresentable.Output
    
    var onTapDelete: ((_ position: Int) -> Void)?
    
    typealias State = (
        users: BehaviorRelay<[User]>,
        serverResponse: BehaviorRelay<ServerResponse?>
    )
    private let state: State = (
        users: BehaviorRelay<[User]>(value: []),
        serverResponse: BehaviorRelay<ServerResponse?>(value: nil)
    )
    
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    
    init(input: DeleteUserViewPresentable.Input, apiService: ApiService) {
        self.input = input
        self.apiService = apiService
        self.output = DeleteUserViewModel.output(state: self.state)
        self.process()
        self.onTapDelete = { position in
            self.deleteUser(position: position)
        }
    }
}

private extension DeleteUserViewModel {
    
    static func output(state: State) -> DeleteUserViewPresentable.Output {
        
        let users = state.users
            .asObservable()
            .asDriver(onErrorJustReturn: [])
        
        let serverResponse = state.serverResponse
            .asObservable()
            .asDriver(onErrorJustReturn: nil)
        
        return (users: users, serverResponse: serverResponse)
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
    
    func deleteUser(position: Int) {
        
        Utils.sharedManager.showActivity()
        
        let params = [
            "id": self.state.users.value[position].id ?? -1
        ]
        
        self.apiService
            .apiCall(type: ServerResponse.self, target: .deleteUser(params: params))
            .map({
                self.state.serverResponse.accept($0)
                var users = self.state.users.value
                users.remove(at: position)
                self.state.users.accept(users)
                Utils.sharedManager.hideActivity()
            })
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
