//
//  EditUserViewModel.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

protocol EditUserViewPresentable {
    
    typealias Input = (
        didPressSubmit: Driver<Void>,
        nameText: Driver<String>,
        dobText: Driver<String>,
        universityText: Driver<String>
    )
    typealias Output = (
        user: Driver<User?>,
        response: Driver<LoginResponse?>
    )
    typealias ViewModelBuilder = (EditUserViewPresentable.Input) -> EditUserViewPresentable
    
    var input: EditUserViewPresentable.Input { get }
    var output: EditUserViewPresentable.Output { get }
}

class EditUserViewModel: EditUserViewPresentable {
    
    var input: EditUserViewPresentable.Input
    var output: EditUserViewPresentable.Output
    
    typealias State = (
        user: BehaviorRelay<User?>,
        response: BehaviorRelay<LoginResponse?>
    )
    private let state: State = (
        user: BehaviorRelay<User?>(value: nil),
        response: BehaviorRelay<LoginResponse?>(value: nil)
    )
    
    private let disposeBag = DisposeBag()
    private let apiService: ApiService
    private let user: User?
    
    private var name = BehaviorRelay<String>(value: "")
    private var dob = BehaviorRelay<String>(value: "")
    private var university = BehaviorRelay<String>(value: "")
    
    init(input: EditUserViewPresentable.Input, apiService: ApiService, user: User?) {
        self.input = input
        self.apiService = apiService
        self.user = user
        self.state.user.accept(user)
        self.output = EditUserViewModel.output(state: self.state)
        self.input.didPressSubmit.drive(onNext: { [weak self] in
            Utils.sharedManager.showActivity()
            self?.updateProfile()
        }).disposed(by: disposeBag)
    }
}

private extension EditUserViewModel {
    
    static func output(state: State) -> EditUserViewPresentable.Output {
        
        let user = state.user
            .asObservable()
            .asDriver(onErrorJustReturn: nil)
        
        let response = state.response
            .asObservable()
            .asDriver(onErrorJustReturn: nil)
        
        return (user: user, response: response)
    }
    
    
    func updateProfile() {
        
        self.input.nameText
            .drive(onNext: { [weak self] value in
                self?.name.accept(value )
            }).disposed(by: self.disposeBag)
        
        self.input.dobText
            .drive(onNext: { [weak self] value in
                self?.dob.accept(value )
            }).disposed(by: self.disposeBag)
        
        self.input.universityText
            .drive(onNext: { [weak self] value in
                self?.university.accept(value )
            }).disposed(by: self.disposeBag)
        
        let params = [
            "id": user?.id ?? -1,
            "name": name.value,
            "dob": dob.value,
            "university": university.value
        ] as [String : Any]
        
        self.apiService
            .apiCall(type: LoginResponse.self, target: .manageUser(params: params))
            .map({ [state] in
                state.response.accept($0)
                state.user.accept($0.data?.user)
                Utils.sharedManager.hideActivity()
            })
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
