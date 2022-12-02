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
        if setCacheImage(cacheKey: cacheKey) { return }

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
    func setImage(pdfUrl: String) {
        let cacheKey = NSString(string: pdfUrl)
        if setCacheImage(cacheKey: cacheKey){ return }
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: pdfUrl),
                let document = CGPDFDocument(url as CFURL),
                let page = document.page(at:1) else {
                print("Load Document Error")
                return
            }
            let pageRect = page.getBoxRect(.mediaBox)
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            let image = renderer.image { context in
                context.fill(pageRect)
                context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                context.cgContext.scaleBy(x: 1.0, y: -1.0)
                context.cgContext.drawPDFPage(page)
            }
            ImageCacheManager.shared.setObject(image, forKey: cacheKey)

            DispatchQueue.main.async {
                self.image = image
            }
        }
        
    }
    
    private func setCacheImage(cacheKey: NSString) -> Bool {
        if let cacheImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cacheImage
            return true
        }
        return false
    }
}
