//
//  BookNetwork.swift
//  BookSearch
//
//  Created by 강휘 on 2022/12/01.
//

import Foundation

protocol BookNetworkProtocol{
    func search(isbn: String, completion: @escaping (Result<Book,Error>)-> Void)
}

final class BookNetwork: BookNetworkProtocol {
    private let network: NetworkManager
    private let endPoint = "https://api.itbook.store/1.0/books/"
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func search(isbn: String, completion: @escaping (Result<Book,Error>)-> Void) {
        network.fetchData(url: "\(endPoint)\(isbn)", dataType: Book.self, completion: completion)
    }
}
