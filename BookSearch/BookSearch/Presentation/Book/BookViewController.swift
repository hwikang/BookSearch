//
//  BookViewController.swift
//  BookSearch
//
//  Created by 강휘 on 2022/12/01.
//


import UIKit
import Combine

final class BookViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    init(isbn: String) {
        super.init(nibName: nil, bundle: nil)
        print(isbn)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
