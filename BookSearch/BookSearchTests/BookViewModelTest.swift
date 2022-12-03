//
//  BookViewModelTest.swift
//  BookSearchTests
//
//  Created by 강휘 on 2022/12/03.
//

import Foundation
import XCTest
@testable import BookSearch
import Combine

class BookViewModelTests: XCTestCase {
    var sut: BookViewModel!
    var output: BookViewModel.Output!
    var trigger: PassthroughSubject<String, Never>!
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        let url = "https://api.itbook.store/1.0/books/"
        let data = dummyBook.data(using: .utf8)
        let mockUrlSession: MockURLSession = MockURLSession.make(url: url, data: data, statusCode: 200)

        sut = BookViewModel(network: BookNetwork(network: NetworkManager(session: mockUrlSession)))
        trigger = PassthroughSubject<String,Never>()
        let input = BookViewModel.Input(trigger: trigger.eraseToAnyPublisher())
        output = sut.transform(input: input)

    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    func test_get_book_data_when_trigger_send() {
        let expectation = XCTestExpectation(description: "Data fetch Triggered")
        //when
        trigger.send("9781617294259")
        
        output.book.sink { book in
            let bookTitle = "Hello Scratch!"
            XCTAssertEqual(bookTitle, book.title)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
        
    }
    
    func test_sort_pdf() {
        let sortedElementArray = sut.sortPDF(pdf: dummyPDF)
        
        XCTAssertEqual("Chapter 3", sortedElementArray[0].key)
        XCTAssertEqual("Appendix", sortedElementArray[3].key)
        XCTAssertEqual("Extra Chapter 4", sortedElementArray[7].key)

    }
    
}
