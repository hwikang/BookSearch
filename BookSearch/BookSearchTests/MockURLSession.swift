//
//  MockURLSession.swift
//  BookSearchTests
//
//  Created by 강휘 on 2022/11/30.
//

import Foundation

class MockURLSession: URLSession {
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    let response: Response
    
    init(response: Response) {
        self.response = response
        super.init(configuration: .default)
    }
    
    override func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask(resumeHandler: {
            completionHandler(self.response.data,
                              self.response.urlResponse,
                              self.response.error)
        })
    }
    static func make(url: String, data: Data?, statusCode: Int) -> MockURLSession {
            let mockURLSession: MockURLSession = {
                let urlResponse = HTTPURLResponse(url: URL(string: url)!,
                                               statusCode: statusCode,
                                               httpVersion: nil,
                                               headerFields: nil)
                let mockResponse: MockURLSession.Response = (data: data,
                                                             urlResponse: urlResponse,
                                                             error: nil)
                let mockUrlSession = MockURLSession(response: mockResponse)
                return mockUrlSession
            }()
            return mockURLSession
        }
    
}


class MockURLSessionDataTask: URLSessionDataTask {
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
       self.resumeHandler = resumeHandler
    }
    override func resume() {
        resumeHandler()
    }
}
