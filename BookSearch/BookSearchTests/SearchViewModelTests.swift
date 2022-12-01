//
//  BookSearchTests.swift
//  BookSearchTests
//
//  Created by 강휘 on 2022/11/30.
//

import XCTest
@testable import BookSearch
import Combine

class SearchViewModelTests: XCTestCase {
    var sut: SearchViewModel!
    var searchText: PassthroughSubject<String, Never>!
    var loadMore: PassthroughSubject<Void, Never>!
    var cancellables = Set<AnyCancellable>()
    var output: SearchViewModel.Output!
    override func setUpWithError() throws {
        let url = "https://api.itbook.store/1.0/search/"
        let data = dummySearchList.data(using: .utf8)
        let mockUrlSession: MockURLSession = MockURLSession.make(url: url, data: data, statusCode: 200)
        sut = SearchViewModel(network: SearchNetwork(network: NetworkManager(session: mockUrlSession)))

        searchText = PassthroughSubject<String,Never>()
        loadMore = PassthroughSubject<Void,Never>()

        let input = SearchViewModel.Input(searchText: searchText.eraseToAnyPublisher() , loadMore: loadMore.eraseToAnyPublisher())
        output = sut.transform(input: input)

    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_데이터_가져올시_리스트_갱신() {
        
        //when
        let expectation = XCTestExpectation(description: "Search Text Input...")
        searchText.send("Hi")
        searchText.send("Hi")
        
        output.bookList
            .dropFirst()
            .sink { books in
            let title = "Just Hibernate"
            XCTAssertEqual(books.first?.title, title)
            expectation.fulfill()
        }.store(in: &cancellables)

        
        wait(for: [expectation], timeout: 2)
    }
    
    func test_searchText_공백추가해도_정상작동() {
        let expectation = XCTestExpectation(description: "Search Text Input...")
        //when
        searchText.send("Hi    ")

        output.bookList
            .dropFirst()
            .sink { books in
            let title = "Just Hibernate"
            XCTAssertEqual(books.first?.title, title)
            expectation.fulfill()
        }.store(in: &cancellables)

        
        wait(for: [expectation], timeout: 2)
        
    }
    
    func test_loadMore_데이터갱신() {
        let expectation = XCTestExpectation(description: "Search Text Input...")
        //when
        searchText.send("Hi")
        output.bookList
            .dropFirst()
            .sink {[weak self] books in
                
                if books.count > 20 {
                    expectation.fulfill()
                }else {
                    self?.loadMore.send()
                }

            }.store(in: &cancellables)
        wait(for: [expectation], timeout: 2)

    }

}
