//
//  ViewController.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import UIKit
import SnapKit
import RxSwift

class SearchViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel = SearchViewModel()
    private let textField = SearchTextField()

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
        textField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(44)
        }
    }

    private func bindViewModel() {
        let searchTrigger = textField.rx.controlEvent([.editingDidEndOnExit]).asObservable()
        let searchText = textField.rx.text.orEmpty.asObservable()
        let input = SearchViewModel.Input(
            searchTrigger: searchTrigger,
            searchText: searchText)
        
        let output = viewModel.transform(input: input)
        
        output.test.bind{ num in
            print(num)
        }.disposed(by: disposeBag)
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
