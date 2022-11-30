//
//  File.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import Foundation
import Combine

class SearchNetwork {
    private let network: NetworkManager = NetworkManager(session: URLSession.shared)
    private let endPoint = "https://api.itbook.store/1.0/search/"
    func search(query: String) async throws -> SearchList {
        return try await network.fetchData(url: "\(endPoint)\(query)", dataType: SearchList.self)
    }
//    
//    func search(query: String) throws -> AnyPublisher<SearchList,Error> {
//        return try network.fetchData(url: "\(endPoint)\(query)", dataType: SearchList.self)
//    }
}
