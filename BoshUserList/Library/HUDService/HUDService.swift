//
//  HUDService.swift
//  BoshUserList
//
//  Created by Heng.Wang on 2020/5/23.
//  Copyright © 2020 Heng.Wang. All rights reserved.
//

import SVProgressHUD
import PromiseKit

typealias HUDServiceCompletion = (() -> Void)

class HUDService {
    static public func configure() {
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    static public func showProgress() {
        SVProgressHUD.show()
    }
    
    static public func hide(completion: HUDServiceCompletion? = nil) {
        if let completion = completion {
            SVProgressHUD.dismiss(completion: completion)
        } else {
          SVProgressHUD.dismiss()
        }
    }
    
    static public func flashError(message: String? = nil, completion: HUDServiceCompletion? = nil) {
        SVProgressHUD.showError(withStatus: "message error")
        after(seconds: 1.5).done{
            HUDService.hide(completion: completion)
        }
    }
    
}
