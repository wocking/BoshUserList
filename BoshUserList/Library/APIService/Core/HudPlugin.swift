//
//  HudPlugin.swift
//  BoshUserList
//
//  Created by Heng.Wang on 2020/5/23.
//  Copyright © 2020 Heng.Wang. All rights reserved.
//

import Moya

let hudPlugin = NetworkActivityPlugin { (state, targetType) in
    if let targetType = targetType as? MultiTarget,
        let hudTargetType = targetType.target as? TargetType & MoyaAddable {
        DispatchQueue.main.async {
            switch state {
            case .began:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                if hudTargetType.isShowHud {
                    HUDService.showProgress()
                }
                
            case .ended:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if hudTargetType.isShowHud {
                    HUDService.hide()
                }
            }
        }
    }
}
