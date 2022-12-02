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
    private let trigger = PassthroughSubject<String,Never>()
    private let viewModel: BookViewModel
    private let isbn: String
    
    private let bookView = BookView()
    
    init(isbn: String, viewModel: BookViewModel) {
        self.viewModel = viewModel
        self.isbn = isbn
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = bookView
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        trigger.send(isbn)
    }
    
    private func bindViewModel() {
        let input = BookViewModel.Input(trigger: trigger.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.book
            .receive(on: DispatchQueue.main)
            .sink {[weak self] book in
                print(book)
                self?.bookView.setContent(book: book)
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
