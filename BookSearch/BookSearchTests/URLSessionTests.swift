//
//  URLSessionTests.swift
//  BookSearchTests
//
//  Created by 강휘 on 2022/11/30.
//

import XCTest
@testable import BookSearch

class URLSessionTests: XCTestCase {
    var url: String!
    
    override func setUpWithError() throws {
        url = "https://api.itbook.store/1.0/search/hello"
    }
       
    override func tearDownWithError() throws {
       url = nil
    }
    
    func test_statusCode_200아닐떄() async {
        
        //given
        let mockUrlSession = MockURLSession.make(url: url, data: nil, statusCode: 300)
        let sut = NetworkManager(session: mockUrlSession)
        
        //when
        var result: NetworkError?

        sut.fetchData(url: url, dataType: SearchList.self) { response in
            if case let .failure(error) = response {
                result = error as? NetworkError
            }
        }
        XCTAssertNotNil(result)

       
    }
    
    func test_data_nil일떄() async {
        
        //given
        let mockUrlSession = MockURLSession.make(url: url, data: nil, statusCode: 200)
        let sut = NetworkManager(session: mockUrlSession)
        
        //when
        var result: NetworkError?
       
        sut.fetchData(url: url, dataType: SearchList.self) { response in
            if case let .failure(error) = response {
                result = error as? NetworkError
            }
        }
        let expection = NetworkError.invalid
        XCTAssertEqual(result, expection)

       
    }
    
    
}
