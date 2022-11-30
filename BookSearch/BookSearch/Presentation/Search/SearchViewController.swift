//
//  ViewController.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    private let viewModel: SearchViewModel = SearchViewModel()
    private let textField = SearchTextField()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDismissKeyboardEvent()
        bindViewModel()
    }
    
    private func setUI() {
        self.view.addSubview(textField)
        
        setConstraint()
    }
    
    private func setConstraint() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        let textFieldConstraints = [
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),            textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)]

        NSLayoutConstraint.activate(textFieldConstraints)
    }

    private func bindViewModel() {
        
        let searchText = textField.textPublisher
        
        let input = SearchViewModel.Input(
            searchText: searchText)
//        
        let output = viewModel.transform(input: input)
        
        output.list.sink { error in
            print("Sink Error \(error)")
        } receiveValue: { searchList in
            print("List \(searchList)")
        }.store(in: &cancellables)

    }
}

extension SearchViewController {
    
    private func setDismissKeyboardEvent() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
