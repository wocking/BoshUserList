//
//  UserTableViewCell.swift
//  BoshUserList
//
//  Created by Heng.Wang on 2020/5/23.
//  Copyright © 2020 Heng.Wang. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var status: UILabel!
    
    var setData: UserList? {
        didSet {
            guard let data = setData
                else { return }
            userImage.setImageWithUrlPath(data.avatar_url)
            userName.text = data.login
            status.isHidden = !data.site_admin
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingView()
    }
    
    private func settingView() {
        status.layer.cornerRadius = 10
        status.text = "STAFF"
    }
}
