//
//  ViewController.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: SearchViewModel
    private var dataSource: UITableViewDiffableDataSource<Section, Book>!
    private let loadMoreSubject = PassthroughSubject<Void, Never>()

    var searchView = SearchView()
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = searchView
        setupTableView()
        setupTextField()
        setDismissKeyboardEvent()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        let searchText = searchView.textField.textPublisher
        let loadMore = loadMoreSubject.eraseToAnyPublisher()
        let input = SearchViewModel.Input(searchText: searchText, loadMore: loadMore)

        let output = viewModel.transform(input: input)
        
        output.bookList
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink {[weak self] books in
            self?.updateTableViewSnapshot(books)
        }.store(in: &cancellables)
        
        output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink {[weak self] errorMessage in
                let dialog = DialogManager.getDialog(title: "NetworkError", message: errorMessage)
                self?.present(dialog, animated: true)
            }
            .store(in: &cancellables)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching, UITableViewDelegate, UITextFieldDelegate {
    enum Section{ case book }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let cellCount = tableView.numberOfRows(inSection: indexPath.section)
            if needLoadMore(row: indexPath.row, cellCount: cellCount){
                loadMoreSubject.send()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? BookTableViewCell {
            let network = BookNetwork(network: NetworkManager(session: URLSession.shared))
            let viewModel = BookViewModel(network: network)
            let viewController = BookViewController(isbn: cell.getISBN(), viewModel: viewModel)
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    

    
    private func setupTableView() {
        searchView.tableView.prefetchDataSource = self
        searchView.tableView.delegate = self
        searchView.tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
        configureDataSource()
    }
    
    private func setupTextField() {
        searchView.textField.delegate = self
    }

    private func updateTableViewSnapshot(_ value: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        snapshot.appendSections([.book])
        snapshot.appendItems(value, toSection: .book)
        dataSource.apply(snapshot)
    }
       
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Book>(tableView: searchView.tableView, cellProvider: { tableView, indexPath, book in

           let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell
            cell?.configure(book: book)
            return cell
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    
    private func needLoadMore(row: Int,cellCount: Int) -> Bool {
        if cellCount % 10 == 0 && row >= cellCount - 1 {
            return true
        }
        return false
    }
}

extension SearchViewController {
    
    private func setDismissKeyboardEvent() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
    }

    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

