//
//  SearchList.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import Foundation

struct SearchList: Decodable {
    var page: Int
    var total: Int
    let books: [Book]
    
    enum Keys: CodingKey {
        case page, total, books
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let pageString = try container.decode(String.self, forKey: Keys.page)
        let totalString = try container.decode(String.self, forKey: Keys.total)
        books = try container.decode([Book].self, forKey: Keys.books)
        guard let pageInt = Int(pageString),
              let totalInt = Int(totalString) else {
            throw NetworkError.failToDecode
        }
        page = pageInt
        total = totalInt
        
        
    }
   
}
