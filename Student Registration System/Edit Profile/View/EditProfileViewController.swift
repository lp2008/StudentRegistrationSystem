//
//  EditProfileViewController.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit
import RxSwift
import RxCocoa
import Loaf

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var universityTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private var imagePicker: ImagePicker!
    private let disposeBag = DisposeBag()
    private var viewModel:  EditProfileViewPresentable!
    var viewModelBuilder: EditProfileViewPresentable.ViewModelBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder((
            didPressSubmit: submitButton.rx.tap.asDriver(),
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

private extension EditProfileViewController {
    
    func setupUI() {
        
        navigationItem.title = "Edit Profile"
        navigationItem.hidesBackButton = false
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        (self.uploadButton.rx.tap).bind(onNext: { [weak self] in
            self?.imagePicker.present(from: self?.uploadButton ?? UIView())
        }).disposed(by: self.disposeBag)
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
                        Loaf("Profile Updated", state: .success, sender: self).show()
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func configureUserData(user: User?) {
        nameTextField.text = user?.name
        dobTextField.text = user?.dob
        universityTextField.text = user?.university
        let userPhoto = user?.photo ?? ""
        let url = URL(string: AppConstants.BASE_URL + userPhoto)
        self.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "profile_photo"), options: [.requestModifier(Utils.sharedManager.modifier)])
    }
}

extension EditProfileViewController: ImageDelegate {
    
    func didSelect(image: UIImage?) {
        if image == nil {
            return
        }
        self.profileImageView.image = image
    }
}
