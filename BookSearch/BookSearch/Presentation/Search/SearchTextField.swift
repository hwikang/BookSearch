//
//  SearchTextField.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import UIKit



class SearchTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.borderStyle = .roundedRect
        self.keyboardType = .default
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
