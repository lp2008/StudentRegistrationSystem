//
//  LoginViewModel.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol LoginViewPresentable {
    
    typealias Input = (
        didPressSubmit: Driver<Void>,
        email: Driver<String>,
        password: Driver<String>
    )
    typealias Output = (loginModel: Driver<LoginResponse?>, ())
    typealias ViewModelBuilder = (LoginViewPresentable.Input) -> LoginViewPresentable
    typealias Validate = (isValid: Driver<Valid>, ())
    
    var input: LoginViewPresentable.Input { get }
    var output: LoginViewPresentable.Output { get }
    var validate: LoginViewPresentable.Validate { get }
    
    var loginSuccess: ((_ role: String) -> Void)? { get }
}

class LoginViewModel: LoginViewPresentable {
    
    var input: LoginViewPresentable.Input
    var output: LoginViewPresentable.Output
    var validate: LoginViewPresentable.Validate
    
    var loginSuccess: ((_ role: String) -> Void)?
    
    typealias Validation = (validate: BehaviorRelay<Valid>, ())
    private let validation: Validation = (validate: BehaviorRelay<Valid>(value: Valid()), ())
    
    typealias State = (loginModel: BehaviorRelay<LoginResponse?>, ())
    private let state: State = (loginModel: BehaviorRelay<LoginResponse?>(value: nil), ())
    
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    
    private let email = BehaviorRelay(value: "")
    private let password = BehaviorRelay(value: "")
    
    init(input: LoginViewPresentable.Input, apiService: ApiService) {
        self.input = input
        self.apiService = apiService
        self.output = LoginViewModel.output(input: input, state: self.state)
        self.validate = LoginViewModel.validate(validation: self.validation)
        self.input.didPressSubmit.drive(onNext: { [weak self] in
            Utils.sharedManager.showActivity()
            self?.process()
        }).disposed(by: disposeBag)
    }
}

private extension LoginViewModel {
    
    static func output(input: LoginViewPresentable.Input, state: State) -> LoginViewPresentable.Output {
        let loginItem = state.loginModel
            .asObservable()
            .asDriver(onErrorJustReturn: nil)
        return (loginModel: loginItem, ())
    }
    
    static func validate(validation: Validation) -> LoginViewPresentable.Validate {
        let valid = validation.validate
            .asObservable()
            .skip(1)
            .asDriver(onErrorJustReturn: Valid())
        return (valid,())
    }
    
    func process() {
        
        let emailObservable = input.email.asObservable()
        emailObservable.subscribe(onNext: { value in
            self.email.accept(value)
        }).disposed(by: self.disposeBag)
        
        let passwordObservable = input.password.asObservable()
        passwordObservable.subscribe(onNext: { value in
            self.password.accept(value)
        }).disposed(by: self.disposeBag)
        
        if self.email.value == "" {
            validation.validate.accept(Valid(isValid: false, message: "Please Enter Email."))
            Utils.sharedManager.hideActivity()
            return
        } else if self.password.value == "" {
            validation.validate.accept(Valid(isValid: false, message: "Please Enter Password."))
            Utils.sharedManager.hideActivity()
            return
        }
        
        let params = [
            "email": email.value,
            "password": password.value
        ]
        
        self.apiService
            .apiCall(type: LoginResponse.self, target: .login(params: params))
            .map({
                self.state.loginModel.accept($0)
                Utils.sharedManager.hideActivity()
            })
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
