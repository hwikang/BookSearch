//
//  SearchTextField.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import UIKit

final class SearchTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.borderStyle = .roundedRect
        self.keyboardType = .default
        
        self.placeholder = "Enter Text."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
