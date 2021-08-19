//
//  AddUserViewController.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit
import RxSwift
import RxCocoa
import Loaf

class AddUserViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var universityTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private var imagePicker: ImagePicker!
    private let disposeBag = DisposeBag()
    private var viewModel:  AddUserViewPresentable!
    var viewModelBuilder: AddUserViewPresentable.ViewModelBuilder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder((
            didPressSubmit: submitButton.rx.tap.asDriver(),
            emailText: emailTextField.rx.text.orEmpty.asDriver(),
            passwordText: passwordTextField.rx.text.orEmpty.asDriver(),
            nameText: nameTextField.rx.text.orEmpty.asDriver(),
            dobText: dobTextField.rx.text.orEmpty.asDriver(),
            universityText: universityTextField.rx.text.orEmpty.asDriver(),
            image: getImage().asDriver(onErrorJustReturn: nil)
        ))
        setupUI()
        setupBinding()
    }
    
    func getImage() -> Observable<UIImage?> {
        return Observable<UIImage?>.create { (observer) -> Disposable in
            observer.onNext(self.profileImageView.image)
            observer.onCompleted()
            return Disposables.create {
                observer.onCompleted()
            }
        }
    }

}

private extension AddUserViewController {
    
    func setupUI() {
        
        navigationItem.title = "Add User"
        navigationItem.hidesBackButton = false
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        (self.uploadButton.rx.tap).bind(onNext: { [weak self] in
            self?.imagePicker.present(from: self?.uploadButton ?? UIView())
        }).disposed(by: self.disposeBag)
    }
    
    func setupBinding() {
        
        self.viewModel.output
            .response
            .drive(onNext: { [weak self] result in
                if result?.status ?? false {
                    self?.resetView()
                }
            }).disposed(by: disposeBag)
        
        self.viewModel.output
            .response
            .drive(onNext: { response in
                if let res = response {
                    if res.status ?? false {
                        Loaf("New User Created", state: .success, sender: self).show()
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func resetView() {
        emailTextField.text = ""
        passwordTextField.text = ""
        nameTextField.text = ""
        dobTextField.text = ""
        universityTextField.text = ""
        profileImageView.image = UIImage(systemName: "person.circle")
    }
}

extension AddUserViewController: ImageDelegate {
    
    func didSelect(image: UIImage?) {
        if image == nil {
            return
        }
        self.profileImageView.image = image
    }
}
