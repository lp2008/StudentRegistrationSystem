//
//  EditUserViewController.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit
import RxSwift
import RxCocoa
import Loaf

class EditUserViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var universityTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel:  EditUserViewPresentable!
    var viewModelBuilder: EditUserViewPresentable.ViewModelBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder((
            didPressSubmit: submitButton.rx.tap.asDriver(),
            nameText: nameTextField.rx.text.orEmpty.asDriver(),
            dobText: dobTextField.rx.text.orEmpty.asDriver(),
            universityText: universityTextField.rx.text.orEmpty.asDriver()
        ))
        setupUI()
        setupBinding()
    }

}

private extension EditUserViewController {
    
    func setupUI() {
        
        navigationItem.title = "Manage User"
        navigationItem.hidesBackButton = false
    }
    
    func setupBinding() {
        
        self.viewModel.output
            .user
            .drive(onNext: { [weak self] result in
                self?.configureUserData(user: result)
            }).disposed(by: disposeBag)
        
        self.viewModel.output
            .response
            .drive(onNext: { response in
                if let res = response {
                    if res.status ?? false {
                        Loaf("User Updated", state: .success, sender: self).show()
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func configureUserData(user: User?) {
        nameTextField.text = user?.name
        dobTextField.text = user?.dob
        universityTextField.text = user?.university
    }
}
