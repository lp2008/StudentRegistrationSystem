//
//  LoginViewController.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit
import RxCocoa
import Loaf
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel: LoginViewPresentable!
    var viewModelBuilder: LoginViewPresentable.ViewModelBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder((
            didPressSubmit: submitButton.rx.tap.asDriver(),
            email: emailTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver()
        ))
        
        setupUI()
        setupBinding()
    }

}

private extension LoginViewController {
    
    func setupUI() {
        emailTextField.text = "mindfreakicup33@gmail.com"
        passwordTextField.text = "test1234"
    }
    
    func setupBinding() {
        self.viewModel.validate.isValid
            .drive(onNext: { value in
                if !value.isValid {
                    Loaf(value.message, state: .error, sender: self).show()
                }
            }).disposed(by: self.disposeBag)
        
        self.viewModel.output.loginModel
            .drive(onNext: { result in
                if let data = result {
                    if (data.status ?? false) {
                        SharedEngine.shared.saveAccessToken(token: data.token ?? "")
                        SharedEngine.shared.saveUserData(user: data.data?.user)
                        self.viewModel.loginSuccess?(data.data?.user?.role ?? "")
                    } else {
                        Loaf("Login failed.", state: .error, sender: self).show()
                    }
                }
            }).disposed(by: self.disposeBag)
    }
}
