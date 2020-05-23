//
//  ImageView+Utility.swift
//  BoshUserList
//
//  Created by Heng.Wang on 2020/5/23.
//  Copyright © 2020 Heng.Wang. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    
    func setImageWithUrlPath(_ path: String, completed: SDExternalCompletionBlock? = nil) {
        self.sd_setImage(with: URL(string: path), completed: completed)
    }
    
    func setLocalWebpImage(url: URL) {
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { (image, data, error, cacheType, finished, url) in
            if let error = error {
                print(error)
            } else {
                self.image = image
            }
        }
    }
    
}
