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
