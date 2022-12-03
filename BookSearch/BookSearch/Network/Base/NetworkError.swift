//
//  NetworkError.swift
//  BookSearch
//
//  Created by 강휘 on 2022/11/30.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case invalid
    case failToDecode(String)
    case dataNil
    case serverError(Int)
}
