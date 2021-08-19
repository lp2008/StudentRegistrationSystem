//
//  AddUserViewModel.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

protocol AddUserViewPresentable {
    
    typealias Input = (
        didPressSubmit: Driver<Void>,
        emailText: Driver<String>,
        passwordText: Driver<String>,
        nameText: Driver<String>,
        dobText: Driver<String>,
        universityText: Driver<String>,
        image: Driver<UIImage?>
    )
    typealias Output = (
        response: Driver<ServerResponse?>,
        ()
    )
    typealias ViewModelBuilder = (AddUserViewPresentable.Input) -> AddUserViewPresentable
    
    var input: AddUserViewPresentable.Input { get }
    var output: AddUserViewPresentable.Output { get }
}

class AddUserViewModel: AddUserViewPresentable {
    
    var input: AddUserViewPresentable.Input
    var output: AddUserViewPresentable.Output
    
    typealias State = (
        response: BehaviorRelay<ServerResponse?>,
        ()
    )
    private let state: State = (
        response: BehaviorRelay<ServerResponse?>(value: nil),
        ()
    )
    
    private let disposeBag = DisposeBag()
    private let apiService: ApiService
    
    private let image = BehaviorRelay<UIImage?>(value: nil)
    private var name = BehaviorRelay<String>(value: "")
    private var dob = BehaviorRelay<String>(value: "")
    private var university = BehaviorRelay<String>(value: "")
    private var email = BehaviorRelay<String>(value: "")
    private var password = BehaviorRelay<String>(value: "")
    
    init(input: AddUserViewPresentable.Input, apiService: ApiService) {
        self.input = input
        self.apiService = apiService
        self.output = AddUserViewModel.output(state: self.state)
        self.input.didPressSubmit.drive(onNext: { [weak self] in
            Utils.sharedManager.showActivity()
            self?.createUser()
        }).disposed(by: disposeBag)
    }
}

private extension AddUserViewModel {
    
    static func output(state: State) -> AddUserViewPresentable.Output {
        
        let response = state.response
            .asObservable()
            .asDriver(onErrorJustReturn: nil)
        
        return (response: response, ())
    }
    
    
    func createUser() {
        
        self.input.image
            .drive(onNext: { [weak self] img in
                self?.image.accept(img ?? UIImage())
            }).disposed(by: self.disposeBag)
        
        self.input.emailText
            .drive(onNext: { [weak self] value in
                self?.email.accept(value )
            }).disposed(by: self.disposeBag)
        
        self.input.passwordText
            .drive(onNext: { [weak self] value in
                self?.password.accept(value )
            }).disposed(by: self.disposeBag)
        
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
        
        var formData: [MultipartFormData] = [MultipartFormData]()
        if let img = image.value {
            let imageData = img.jpegData(compressionQuality: 0.5)
            formData.append(MultipartFormData(provider: .data(imageData!), name: "photo", fileName: "user.jpeg", mimeType: "image/jpeg"))
        }
        formData.append(MultipartFormData(provider: .data(email.value.data(using: .utf8)!), name: "email"))
        formData.append(MultipartFormData(provider: .data(password.value.data(using: .utf8)!), name: "password"))
        formData.append(MultipartFormData(provider: .data(name.value.data(using: .utf8)!), name: "name"))
        formData.append(MultipartFormData(provider: .data(dob.value.data(using: .utf8)!), name: "dob"))
        formData.append(MultipartFormData(provider: .data(university.value.data(using: .utf8)!), name: "university"))
        
        self.apiService
            .apiCall(type: ServerResponse.self, target: .createUser(formData: formData))
            .map({ [state] in
                state.response.accept($0)
                Utils.sharedManager.hideActivity()
            })
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
