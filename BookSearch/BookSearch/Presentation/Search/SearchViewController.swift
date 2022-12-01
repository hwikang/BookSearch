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
    private let viewModel: SearchViewModel = SearchViewModel(network: SearchNetwork(network: NetworkManager(session: URLSession.shared)))
    private var dataSource: UITableViewDiffableDataSource<Section, Book>!
    private let loadMoreSubject = PassthroughSubject<Void, Never>()

    var searchView = SearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = searchView
        setupTableView()
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
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    enum Section{ case book }
    
    private func setupTableView() {
        searchView.tableView.prefetchDataSource = self
        searchView.tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
        configureDataSource()
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

