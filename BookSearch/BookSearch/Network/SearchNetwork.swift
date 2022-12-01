//
//  File.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import Foundation
import Combine

final class SearchNetwork {
    private let network: NetworkManager
    private let endPoint = "https://api.itbook.store/1.0/search/"
    
    init(network: NetworkManager) {
        self.network = network
    }
    func search(query: String, page: Int, completion: @escaping (Result<SearchList,Error>)-> Void) {
        network.fetchData(url: "\(endPoint)\(query)/\(page)", dataType: SearchList.self, completion: completion)
    }
}
