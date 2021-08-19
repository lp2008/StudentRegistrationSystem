//
//  MenuViewController.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "MenuTableViewCell"
    private let disposeBag = DisposeBag()
    
    private var viewModel: MenuViewPresentable!
    var viewModelBuilder: MenuViewPresentable.ViewModelBuilder!
    
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

private extension MenuViewController {
    
    func setupUI() {
        
        navigationItem.title = "Menu"
        navigationItem.hidesBackButton = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
    }
    
    @objc func logoutTapped() {
        self.viewModel.onTapLogout?()
    }
    
    func setupBinding() {
        
        viewModel.output.menuOptions
            .drive(tableView.rx.items(cellIdentifier: cellIdentifier, cellType: UITableViewCell.self)) { (position, menu, cell) in
                cell.textLabel?.text = menu
                cell.selectionStyle = .none
            }.disposed(by: self.disposeBag)
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.onTapMenu?(indexPath.row)
    }
}
