//
//  UIImageView.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import UIKit

extension UIImageView {
    func setImage(url: String) {
        
        let cacheKey = NSString(string: url)
        if let cacheImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cacheImage
            return
        }

        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: url),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                
                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            
        }
    }
}
