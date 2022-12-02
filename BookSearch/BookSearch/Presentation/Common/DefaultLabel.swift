//
//  DefaultLabel.swift
//  BookSearch
//
//  Created by 강휘 on 2022/12/02.
//

import UIKit

final class DefaultLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        font = UIFont.systemFont(ofSize: 14, weight: .light)
        textAlignment = .center
        numberOfLines = 0

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
    
