//
//  RHNetworkAPIImplementationTests.swift
//
//
//  Created by Chung Han Hsin on 2024/1/24.
//

import XCTest
@testable import RHNetwork
@testable import RHNetworkAPI

class RHNetworkAPIImplementationTests: XCTestCase {
    func test_get_onSuccessfulResult() {
        let (sut, client) = makeSUT()
        let expectedResult = HTTPClientResult.success(anyData, anyHttpURLResponse)
        expectGet(sut, client: client, toCompleteWithResult: expectedResult) {
            client.complete(with: anyHttpURLResponse.statusCode, data: anyData)
        }
    }
    
    func test_post_onSuccessfulResult() {
        let (sut, client) = makeSUT()
        let expectedResult = HTTPClientResult.success(anyData, anyHttpURLResponse)
        expectPost(sut, client: client, toCompleteWithResult: expectedResult) {
            client.complete(with: anyHttpURLResponse.statusCode, data: anyData)
        }
    }
    
    func test_get_onFailureWithResponseErrorResult() {
        let (sut, client) = makeSUT()
        let expectedResult = HTTPClientResult.failure(.responseError)
        expectGet(sut, client: client, toCompleteWithResult: expectedResult) {
            client.complete(with: .responseError)
        }
    }
    
    func test_post_onFailureWithResponseErrorResult() {
        let (sut, client) = makeSUT()
        let expectedResult = HTTPClientResult.failure(.responseError)
        expectPost(sut, client: client, toCompleteWithResult: expectedResult) {
            client.complete(with: .responseError)
        }
    }
}

private extension RHNetworkAPIImplementationTests {
    var anyData: Data { .init("any data".utf8) }
    var anyURL: URL { .init(string: "http://any-url.com")! }
    var anyPath: String { "any-path" }
    var anyHttpURLResponse: HTTPURLResponse {
        HTTPURLResponse(url: anyURL.appending(path: anyPath), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    class HTTPClientSpy: HTTPClient {
        var messages = [(request: RequestType, completion: (HTTPClientResult) -> Void)]()
        func request(with request: RequestType, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((request, completion))
        }
        
        func complete(with error: HTTPClientError, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(with statusCode: Int, data: Data, at index: Int = 0) {
            let httpURLResponse = HTTPURLResponse(
                url: messages[index].request.fullURL,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil)!
            messages[index].completion(.success(data, httpURLResponse))
        }
    }
    
    func makeSUT() -> (RHNetworkAPIImplementation, HTTPClientSpy) {
        let clientSpy = HTTPClientSpy()
        let sut = RHNetworkAPIImplementation.init(domain: anyURL, client: clientSpy)
        return (sut, clientSpy)
    }
}

private extension RHNetworkAPIImplementationTests {
    func expectGet(_ sut: RHNetworkAPIImplementation, client: HTTPClientSpy, toCompleteWithResult expectedResult: HTTPClientResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion ...")
        sut.get(path: anyPath) { result in
            switch (result, expectedResult) {
            case let (.success(data, response), .success(expectedData, expectedResponse)):
                XCTAssertEqual(data, expectedData)
                XCTAssertEqual(response.statusCode, expectedResponse.statusCode)
                XCTAssertEqual(response.url, expectedResponse.url)
            case let (.failure(error), .failure(expectedError)):
                XCTAssertEqual(error, expectedError)
            default:
                XCTFail("Expected result \(expectedResult) got \(result) insteasd")
            }
            exp.fulfill()
        }
        XCTAssertEqual(client.messages[0].request.method, .get)
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    func expectPost(_ sut: RHNetworkAPIImplementation, client: HTTPClientSpy, toCompleteWithResult expectedResult: HTTPClientResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion ...")
        sut.post(path: anyPath, body: nil) { result in
            switch (result, expectedResult) {
            case let (.success(data, response), .success(expectedData, expectedResponse)):
                XCTAssertEqual(data, expectedData)
                XCTAssertEqual(response.statusCode, expectedResponse.statusCode)
                XCTAssertEqual(response.url, expectedResponse.url)
            case let (.failure(error), .failure(expectedError)):
                XCTAssertEqual(error, expectedError)
            default:
                XCTFail("Expected result \(expectedResult) got \(result) insteasd")
            }
            exp.fulfill()
        }
        XCTAssertEqual(client.messages[0].request.method, .post)
        action()
        wait(for: [exp], timeout: 1.0)
    }
}
