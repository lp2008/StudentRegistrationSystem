//
//  ChangePasswordViewModel.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol ChangePasswordViewPresentable {
    
    typealias Input = (
        didPressSubmit: Driver<Void>,
        currentPassword: Driver<String>,
        newPassword: Driver<String>,
        retypePassword: Driver<String>
    )
    typealias Output = (serverResponse: Driver<ServerResponse?>, ())
    typealias ViewModelBuilder = (ChangePasswordViewPresentable.Input) -> ChangePasswordViewPresentable
    typealias Validate = (isValid: Driver<Valid>, ())
    
    var input: ChangePasswordViewPresentable.Input { get }
    var output: ChangePasswordViewPresentable.Output { get }
    var validate: ChangePasswordViewPresentable.Validate { get }
    
    var loginSuccess: ((_ role: String) -> Void)? { get }
}

class ChangePasswordViewModel: ChangePasswordViewPresentable {
    
    var input: ChangePasswordViewPresentable.Input
    var output: ChangePasswordViewPresentable.Output
    var validate: ChangePasswordViewPresentable.Validate
    
    var loginSuccess: ((_ role: String) -> Void)?
    
    typealias Validation = (validate: BehaviorRelay<Valid>, ())
    private let validation: Validation = (validate: BehaviorRelay<Valid>(value: Valid()), ())
    
    typealias State = (serverResponse: BehaviorRelay<ServerResponse?>, ())
    private let state: State = (serverResponse: BehaviorRelay<ServerResponse?>(value: nil), ())
    
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    
    private let currentPassword = BehaviorRelay(value: "")
    private let newPassword = BehaviorRelay(value: "")
    private let retypePassword = BehaviorRelay(value: "")
    
    init(input: ChangePasswordViewPresentable.Input, apiService: ApiService) {
        self.input = input
        self.apiService = apiService
        self.output = ChangePasswordViewModel.output(input: input, state: self.state)
        self.validate = ChangePasswordViewModel.validate(validation: self.validation)
        self.input.didPressSubmit.drive(onNext: { [weak self] in
            Utils.sharedManager.showActivity()
            self?.process()
        }).disposed(by: disposeBag)
    }
}

private extension ChangePasswordViewModel {
    
    static func output(input: ChangePasswordViewPresentable.Input, state: State) -> ChangePasswordViewPresentable.Output {
        let serverResponse = state.serverResponse
            .asObservable()
            .asDriver(onErrorJustReturn: nil)
        return (serverResponse: serverResponse, ())
    }
    
    static func validate(validation: Validation) -> ChangePasswordViewPresentable.Validate {
        let valid = validation.validate
            .asObservable()
            .skip(1)
            .asDriver(onErrorJustReturn: Valid())
        return (valid,())
    }
    
    func process() {
        
        let currentPassObservable = input.currentPassword.asObservable()
        currentPassObservable.subscribe(onNext: { value in
            self.currentPassword.accept(value)
        }).disposed(by: self.disposeBag)
        
        let passwordObservable = input.newPassword.asObservable()
        passwordObservable.subscribe(onNext: { value in
            self.newPassword.accept(value)
        }).disposed(by: self.disposeBag)
        
        let retypePasswordObservable = input.retypePassword.asObservable()
        retypePasswordObservable.subscribe(onNext: { value in
            self.retypePassword.accept(value)
        }).disposed(by: self.disposeBag)
        
        if self.currentPassword.value == "" {
            validation.validate.accept(Valid(isValid: false, message: "Please Enter Current Password."))
            Utils.sharedManager.hideActivity()
            return
        } else if self.newPassword.value == "" {
            validation.validate.accept(Valid(isValid: false, message: "Please Enter New Password."))
            Utils.sharedManager.hideActivity()
            return
        } else if self.retypePassword.value == "" {
            validation.validate.accept(Valid(isValid: false, message: "Please Retype New Password again."))
            Utils.sharedManager.hideActivity()
            return
        } else if self.newPassword.value != self.retypePassword.value {
            validation.validate.accept(Valid(isValid: false, message: "New Password and Retype password doesn't matched. "))
            Utils.sharedManager.hideActivity()
            return
        }
        
        let params = [
            "passwordCurrent": currentPassword.value,
            "password": newPassword.value
        ]
        
        self.apiService
            .apiCall(type: ServerResponse.self, target: .changePassword(params: params))
            .map({
                self.state.serverResponse.accept($0)
                Utils.sharedManager.hideActivity()
            })
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
