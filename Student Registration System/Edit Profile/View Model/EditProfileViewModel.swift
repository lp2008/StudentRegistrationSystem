//
//  EditProfileViewModel.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

protocol EditProfileViewPresentable {
    
    typealias Input = (
        didPressSubmit: Driver<Void>,
        nameText: Driver<String>,
        dobText: Driver<String>,
        universityText: Driver<String>,
        image: Driver<UIImage?>
    )
    typealias Output = (
        user: Driver<User?>,
        response: Driver<LoginResponse?>
    )
    typealias ViewModelBuilder = (EditProfileViewPresentable.Input) -> EditProfileViewPresentable
    
    var input: EditProfileViewPresentable.Input { get }
    var output: EditProfileViewPresentable.Output { get }
}

class EditProfileViewModel: EditProfileViewPresentable {
    
    var input: EditProfileViewPresentable.Input
    var output: EditProfileViewPresentable.Output
    
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
    
    private let image = BehaviorRelay<UIImage?>(value: nil)
    private var name = BehaviorRelay<String>(value: "")
    private var dob = BehaviorRelay<String>(value: "")
    private var univeristy = BehaviorRelay<String>(value: "")
    
    init(input: EditProfileViewPresentable.Input, apiService: ApiService) {
        self.input = input
        self.apiService = apiService
        self.output = EditProfileViewModel.output(state: self.state)
        self.input.didPressSubmit.drive(onNext: { [weak self] in
            Utils.sharedManager.showActivity()
            self?.updateProfile()
        }).disposed(by: disposeBag)
        self.state.user.accept(SharedEngine.shared.getUserData())
    }
}

private extension EditProfileViewModel {
    
    static func output(state: State) -> EditProfileViewPresentable.Output {
        
        let user = state.user
            .asObservable()
            .asDriver(onErrorJustReturn: nil)
        
        let response = state.response
            .asObservable()
            .asDriver(onErrorJustReturn: nil)
        
        return (user: user, response: response)
    }
    
    
    func updateProfile() {
        
        self.input.image
            .drive(onNext: { [weak self] img in
                self?.image.accept(img ?? UIImage())
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
                self?.univeristy.accept(value )
            }).disposed(by: self.disposeBag)
        
        var formData: [MultipartFormData] = [MultipartFormData]()
        if let img = image.value {
            let imageData = img.jpegData(compressionQuality: 0.5)
            formData.append(MultipartFormData(provider: .data(imageData!), name: "photo", fileName: "user.jpeg", mimeType: "image/jpeg"))
        }
        formData.append(MultipartFormData(provider: .data(name.value.data(using: .utf8)!), name: "name"))
        formData.append(MultipartFormData(provider: .data(dob.value.data(using: .utf8)!), name: "dob"))
        formData.append(MultipartFormData(provider: .data(univeristy.value.data(using: .utf8)!), name: "university"))
        
        self.apiService
            .apiCall(type: LoginResponse.self, target: .editProfile(formData: formData))
            .map({ [state] in
                state.response.accept($0)
                state.user.accept($0.data?.user)
                SharedEngine.shared.saveUserData(user: state.user.value)
                Utils.sharedManager.hideActivity()
            })
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
