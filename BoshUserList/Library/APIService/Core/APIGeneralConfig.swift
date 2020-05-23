//
//  APIGeneralConfig.swift
//  BoshUserList
//
//  Created by Heng.Wang on 2020/5/23.
//  Copyright © 2020 Heng.Wang. All rights reserved.
//

import Moya

protocol MoyaAddable {
    var isShowHud: Bool { get }
}
 
extension TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
}

