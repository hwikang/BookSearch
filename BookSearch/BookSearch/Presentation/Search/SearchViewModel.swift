//
//  SearchViewModel.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import Foundation
import Combine

final class SearchViewModel {
    private let network: SearchNetwork
    private var cancellables = Set<AnyCancellable>()
    private let bookList = CurrentValueSubject<[Book],Never>([])
    private let errorMessage = PassthroughSubject<String,Never>()
    
    private var currentQuery: String = ""
    private var currentPage: Int = 1

    struct Input {
        let searchText: AnyPublisher<String,Never>
        let loadMore: AnyPublisher<Void,Never>
    }
    struct Output {
        let bookList: AnyPublisher<[Book],Never>
        let errorMessage: AnyPublisher<String,Never>
    }
    
    init(network: SearchNetwork){
        self.network = network
    }
    
    func transform(input: Input) -> Output {
        input.searchText.debounce(for: 0.5, scheduler: DispatchQueue.main)
            .filter{ $0.count>=2 }
            .map{ text in
                if let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                    return encoded
                }
                return text
            }
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
            
        return Output(bookList: bookList.eraseToAnyPublisher(), errorMessage: errorMessage.eraseToAnyPublisher())
    }
    
    private func search(query: String) {
        currentQuery = query
        currentPage = 1
        network.search(query: currentQuery, page: currentPage) {[weak self] searchResult in
            switch searchResult {
            case .success(let searchList):
                self?.bookList.send(searchList.books)
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
                if let currentBookList = self?.bookList.value {
                    let newBookList = searchList.books
                    let mergedList = currentBookList + newBookList
                    self?.bookList.send(mergedList)

                }
            case .failure(let error):
                self?.onFailSearch(error: error)
            }
        }
    }
    
    private func onFailSearch(error: Error) {
        if let error = error as? URLError {
            errorMessage.send(error.localizedDescription)        
        }else if let error = error as? NetworkError {
            print("Search Error \(error)")
            
        }
    }
    
}
