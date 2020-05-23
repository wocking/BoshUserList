//
//  UserListAPI.swift
//  BoshUserList
//
//  Created by Heng.Wang on 2020/5/23.
//  Copyright © 2020 Heng.Wang. All rights reserved.
//

import Foundation
import Moya

//MARK:- API名稱＆參數
enum RandomUserService {
    case getUserList(_ page: Int)
}

//MARK:- 個別API設定
extension RandomUserService: TargetType, MoyaAddable {
    var baseURL: URL {
        switch self {
        case .getUserList:
            return URL(string: "https://api.github.com/users?")!
        }
    }
    // 設定API路徑及Get參數
    var path: String {
        switch self {
        case .getUserList:
            return ""
        }
    }
    // 設定API Type
    var method: Moya.Method {
        switch self {
        case .getUserList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .getUserList(page):
            return .requestParameters(parameters: ["since":"\(page)"]
                , encoding: URLEncoding.default)
        }
    }
    
    // 針對個別API設定是否顯示Hud
    var isShowHud: Bool {
        switch self {
        case .getUserList:
            return false
        }
    }
}

