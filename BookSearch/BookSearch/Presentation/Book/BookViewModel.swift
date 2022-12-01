//
//  BookViewModel.swift
//  BookSearch
//
//  Created by 강휘 on 2022/12/01.
//

import Foundation
import Combine

final class BookViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let book = PassthroughSubject<Book,Never>()
    private let errorMessage = PassthroughSubject<String,Never>()

    private let network: BookNetworkProtocol
    init(network: BookNetworkProtocol) {
        self.network = network
    }
    struct Input {
        var trigger: AnyPublisher<String,Never>
    }
    
    struct Output {
        var book: AnyPublisher<Book,Never>
        var errorMessage: AnyPublisher<String,Never>
    }
    
    func transform(input: Input) -> Output {
        input.trigger
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] isbn in
                print("Triggered")
            self?.searchBook(isbn: isbn)
            
        }.store(in: &cancellables)
        
        return Output(book: book.eraseToAnyPublisher(),errorMessage: errorMessage.eraseToAnyPublisher())
    }
    
    private func searchBook(isbn: String) {

        network.search(isbn: isbn) {[weak self] searchResult in
            switch searchResult {
            case .success(let book):
                self?.book.send(book)
            case .failure(let error):
                self?.onFailSearch(error: error)
            }
        }
    }
    //Todo: 중복 제거?
    private func onFailSearch(error: Error) {
        if let error = error as? URLError {
            errorMessage.send(error.localizedDescription)
        }else if let error = error as? NetworkError {
            print("Search Error \(error)")
            
        }
    }
    
}
