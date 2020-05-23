//
//  UserListModel.swift
//  BoshUserList
//
//  Created by Heng.Wang on 2020/5/23.
//  Copyright © 2020 Heng.Wang. All rights reserved.
//

import Foundation

struct UserList: Codable {
    let login: String
    let avatar_url: String
    let site_admin: Bool 
}
 

typealias UserListModel = [UserList]
