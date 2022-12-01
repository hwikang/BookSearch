//
//  SearchViewModel.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import Foundation
import Combine

class SearchViewModel {
    private let network: SearchNetwork
    private var cancellables = Set<AnyCancellable>()
    @Published var bookList = [Book]()
    private var currentQuery: String = ""
    private var currentPage: Int = 1
    
    struct Input {
        let searchText: AnyPublisher<String,Never>
        let loadMore: AnyPublisher<Void,Never>
    }
    struct Output {
        let bookList: Published<[Book]>.Publisher
    }
    
    init(network: SearchNetwork){
        self.network = network
    }
    
    func transform(input: Input) -> Output {
        input.searchText.debounce(for: 0.5, scheduler: DispatchQueue.main)
            .filter{ $0.count>=2 }
            .receive(on: DispatchQueue.global(qos: .background))
            .sink {[weak self] text in
                self?.search(query: text)
            }
            .store(in: &cancellables)
        input.loadMore
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] in
                self?.loadMore()
            }
            .store(in: &cancellables)
            
        return Output(bookList: $bookList)
    }
    
    func getListCount() -> Int {
        return bookList.count
    }
    
    private func search(query: String) {
        currentQuery = query
        currentPage = 1
        network.search(query: currentQuery, page: currentPage) {[weak self] searchResult in
            switch searchResult {
            case .success(let searchList):
                self?.bookList = searchList.books
            case .failure(let error):
                self?.onFailSearch(error: error)
            }
        }
    }
    
    
    private func loadMore() {
        currentPage += 1
        network.search(query: currentQuery, page: currentPage) {[weak self] searchResult in
            switch searchResult {
            case .success(let searchList):
                if let currentBookList = self?.bookList {
                    let newBookList = searchList.books
                    self?.bookList = currentBookList + newBookList
                }
            case .failure(let error):
                self?.onFailSearch(error: error)
            }
        }
    }
    
    private func onFailSearch(error: Error) {
        if let error = error as? URLError {
            print("Search URLError \(error)")
        }else {
            print("Search Error \(error)")
        }
    }
    
}
