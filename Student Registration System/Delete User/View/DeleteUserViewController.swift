//
//  DeleteUserViewController.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit
import Loaf
import RxCocoa
import RxSwift

class DeleteUserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "UserTableViewCell"
    private let disposeBag = DisposeBag()
    
    private var viewModel: DeleteUserViewPresentable!
    var viewModelBuilder: DeleteUserViewPresentable.ViewModelBuilder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder((
            (),
            ()
        ))
        
        setupUI()
        setupBinding()
    }

}

private extension DeleteUserViewController {
    
    func setupUI() {
        
        navigationItem.title = "Delete User"
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
    }
    
    func setupBinding() {
        
        viewModel.output.users
            .drive(tableView.rx.items(cellIdentifier: cellIdentifier, cellType: UserTableViewCell.self)) { (position, user, cell) in
                cell.configureCell(user: user)
                cell.onTapDelete = {
                    self.viewModel.onTapDelete?(position)
                }
                cell.selectionStyle = .none
            }.disposed(by: self.disposeBag)
    }
}

extension DeleteUserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
