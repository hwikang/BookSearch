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
    let authors: String?
    let publisher: String?
    let language: String?
    let isbn10: String?
    let pages: String?
    let year: String?
    let rating: String?
    let desc: String?
    let pdf: [String:String]?
  
}
