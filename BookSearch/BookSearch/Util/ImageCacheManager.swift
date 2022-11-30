//
//  ImageCacheManager.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString,UIImage>()
    private init() {}
}
