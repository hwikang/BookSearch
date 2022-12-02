//
//  LinkButton.swift
//  BookSearch
//
//  Created by 강휘 on 2022/12/02.
//

import UIKit
import SafariServices


final class LinkButton: UIButton {
    private let url: String
    init(url: String) {
        self.url = url
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        addTarget(self, action: #selector(pressed), for: .touchUpInside)
    }
    
    @objc func pressed() {
        if let url = URL(string: url) {
            let safariVC = SFSafariViewController(url: url)
            let keyWindow = UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
            
            let rootVC = keyWindow?.rootViewController
            rootVC?.present(safariVC, animated: true)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
