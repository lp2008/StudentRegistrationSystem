//
//  ManageUserViewController.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit
import RxCocoa
import RxSwift

class ManageUserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "UserTableViewCell"
    private let disposeBag = DisposeBag()
    
    private var viewModel: UserListViewPresentable!
    var viewModelBuilder: UserListViewPresentable.ViewModelBuilder!
    
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

private extension ManageUserViewController {
    
    func setupUI() {
        
        navigationItem.title = "All Users"
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
    }
    
    func setupBinding() {
        
        viewModel.output.users
            .drive(tableView.rx.items(cellIdentifier: cellIdentifier, cellType: UserTableViewCell.self)) { (position, user, cell) in
                cell.configureCell(user: user)
                cell.deleteButton.isHidden = true
                cell.selectionStyle = .none
            }.disposed(by: self.disposeBag)
    }
}

extension ManageUserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.clickUser?(indexPath.row)
    }
}
