//
//  ChangePasswordViewController.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit
import RxCocoa
import Loaf
import RxSwift

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel: ChangePasswordViewPresentable!
    var viewModelBuilder: ChangePasswordViewPresentable.ViewModelBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder((
            didPressSubmit: submitButton.rx.tap.asDriver(),
            currentPassword: currentPasswordTextField.rx.text.orEmpty.asDriver(),
            newPassword: newPasswordTextField.rx.text.orEmpty.asDriver(),
            retypePassword: retypePasswordTextField.rx.text.orEmpty.asDriver()
        ))
        
        setupUI()
        setupBinding()
    }

}

private extension ChangePasswordViewController {
    
    func setupUI() {
        navigationItem.title = "Change Password"
        navigationItem.hidesBackButton = false
    }
    
    func resetView() {
        currentPasswordTextField.text = ""
        newPasswordTextField.text = ""
        retypePasswordTextField.text = ""
    }
    
    func setupBinding() {
        self.viewModel.validate.isValid
            .drive(onNext: { value in
                if !value.isValid {
                    Loaf(value.message, state: .error, sender: self).show()
                }
            }).disposed(by: self.disposeBag)
        
        self.viewModel.output.serverResponse
            .drive(onNext: { result in
                if let data = result {
                    if (data.status ?? false) {
                        Loaf("Password Changed", state: .success, sender: self).show()
                        self.resetView()
                    } else {
                        Loaf("Password Changing failed.", state: .error, sender: self).show()
                    }
                }
            }).disposed(by: self.disposeBag)
    }
}
