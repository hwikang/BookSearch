//
//  Book.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import Foundation

struct Book: Decodable, Hashable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}
