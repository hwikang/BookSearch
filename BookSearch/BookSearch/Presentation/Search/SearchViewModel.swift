//
//  SearchViewModel.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import Foundation
import Combine

class SearchViewModel {
    private let network = SearchNetwork()
    private var cancellables = Set<AnyCancellable>()
    @Published var bookList = [Book]()
    
    struct Input {
        let searchText: AnyPublisher<String,Never>
    }
    struct Output {
        let bookList: Published<[Book]>.Publisher
    }
    func transform(input: Input) -> Output {
        input.searchText.debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink {[unowned self] text in
                print("Search \(text)")
                self.search(query: text)
            }.store(in: &cancellables)
        
            
        return Output(bookList: $bookList)
    }
    
    private func search(query: String) {
        network.search(query: query) {[weak self] searchResult in
            switch searchResult {
            case .success(let searchList):
                self?.bookList = searchList.books
            case .failure(let error):
                if let error = error as? URLError {
                    print("Search URLError \(error)")
                }else {
                    print("Search Error \(error)")
                }
            }
        }
    }
    
}
