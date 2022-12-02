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
            self?.searchBook(isbn: isbn)
            
        }.store(in: &cancellables)
        
        return Output(book: book.eraseToAnyPublisher(),errorMessage: errorMessage.eraseToAnyPublisher())
    }
    
    func sortPDF(pdf:[String: String]) -> [Dictionary<String, String>.Element] {
        let sortedPDF = pdf.sorted { first, second in
            if first.key.contains("Extra") {
                if second.key.contains("Extra") {
                    return compareNumber(firstKey: first.key, secondKey: second.key)
                }else {
                    return false
                }
            } else if first.key.contains("Appendix") {
                if second.key.contains("Extra") {
                   return true
                }else if second.key.contains("Appendix"){
                    return compareNumber(firstKey: first.key, secondKey: second.key)
                }else {
                    return false
                }
            } else {
                if second.key.contains("Appendix") || second.key.contains("Extra") {
                    return true
                }else {
                    return compareNumber(firstKey: first.key, secondKey: second.key)
                }
            }
        }
        return sortedPDF
    }
    
    private func compareNumber(firstKey:String, secondKey: String)  -> Bool{
        if let firstNum = firstKey.last?.wholeNumberValue, let lastNum = secondKey.last?.wholeNumberValue {
                return firstNum < lastNum
        }
        return true
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
    
    private func onFailSearch(error: Error) {
        if let error = error as? URLError {
            errorMessage.send(error.localizedDescription)
        }else if let error = error as? NetworkError {
            print("Search Error \(error)")
        }
    }
    
}
