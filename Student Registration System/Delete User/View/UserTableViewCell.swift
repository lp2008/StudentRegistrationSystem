//
//  UserTableViewCell.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteAction(_ sender: UIButton) {
        self.onTapDelete?()
    }
    
    var onTapDelete: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(user: User?) {
        let url = URL(string: AppConstants.BASE_URL + (user?.photo ?? ""))
        self.profileImageView.kf.setImage(with: url, options: [.requestModifier(Utils.sharedManager.modifier)])
        profileNameLabel.text = user?.name
        deleteButton.isHidden = user?.role == "Admin" ? true : false
    }
    
}
