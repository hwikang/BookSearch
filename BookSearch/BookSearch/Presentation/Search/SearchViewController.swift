//
//  ViewController.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: SearchViewModel = SearchViewModel(network: SearchNetwork(network: NetworkManager(session: URLSession.shared)))
    private var dataSource: UITableViewDiffableDataSource<Section, Book>!
    private let loadMoreSubject = PassthroughSubject<Void, Never>()
    private let textField = SearchTextField()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = Layout.tableViewCellHeight
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupTableView()
        setDismissKeyboardEvent()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        let searchText = textField.textPublisher
        let loadMore = loadMoreSubject.eraseToAnyPublisher()
        let input = SearchViewModel.Input(searchText: searchText, loadMore: loadMore)

        let output = viewModel.transform(input: input)
        
        output.bookList
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink {[weak self] books in
            self?.updateTableViewSnapshot(books)
        }.store(in: &cancellables)
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    enum Section{ case book }
    
    private func setupTableView() {
        tableView.prefetchDataSource = self
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
        configureDataSource()
    }

    private func updateTableViewSnapshot(_ value: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        snapshot.appendSections([.book])
        snapshot.appendItems(value, toSection: .book)
        dataSource.apply(snapshot)
    }
       
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Book>(tableView: tableView, cellProvider: { tableView, indexPath, book in

           let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell
            
            cell?.titleLabel.text = book.title
            cell?.subTitleLabel.text = book.subtitle
            cell?.priceLabel.text = book.price
            cell?.isbnLabel.text = book.isbn13
            cell?.urlLabel.text = book.url
            cell?.bookImage.setImage(url: book.image)
            return cell
        })
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if needLoadMore(row: indexPath.row){
                loadMoreSubject.send()
            }
        }
    }
    
    private func needLoadMore(row: Int) -> Bool {
        let dataCount = viewModel.getListCount()
        if dataCount % 10 == 0 && row >= dataCount - 1 {
            return true
        }
        return false
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

extension SearchViewController {
    
    private func setUI() {
        [textField, tableView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraint()
    }
    
    private func setConstraint() {
        let textFieldConstraints = [
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),            textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)]
        let tableViewConstraints = [
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)]

        NSLayoutConstraint.activate(textFieldConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
    }

}
