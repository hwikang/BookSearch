//
//  ImageCacheManager.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString,UIImage>()
    private init() {}
}
