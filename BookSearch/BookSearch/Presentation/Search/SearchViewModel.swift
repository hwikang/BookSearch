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
        input.searchText.debounce(for: 0.5, scheduler: RunLoop.main)
            .sink {[unowned self] text in
                Task {
                    await self.search(query: text)
                }
            }.store(in: &cancellables)
        
            
        return Output(bookList: $bookList)
    }
    
    
    private func search(query: String) async {
        do {
            let result = try await network.search(query: query)
            bookList = result.books
        } catch {
            if let error = error as? URLError {
                print("Search URLError \(error)")
            }else {
                print("Search Error \(error)")
            }
        }
    }
    
}
