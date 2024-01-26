//
//  RHNetworkAPIImplementation.swift
//
//
//  Created by Chung Han Hsin on 2024/1/24.
//
import Foundation
import RHNetwork

enum RequestError: Error {
    case failedToTransferJsonToData
}

class RHNetworkAPIImplementation: RHNetworkAPIProtocol {
    let domain: URL
    let client: HTTPClient
    init(domain: URL, client: HTTPClient=URLSessionHTTPClient()) {
        self.domain = domain
        self.client = client
    }
    
    private struct Request: RequestType {
        var queryItems: [URLQueryItem]
        var baseURL: URL
        var path: String
        var method: RHNetwork.HTTPMethod
        var body: Data?
        var headers: [String : String]?
        init(baseURL: URL, path: String, method: RHNetwork.HTTPMethod, queryItems:[URLQueryItem]=[], body: Data? = nil, headers: [String : String]? = nil) {
            self.baseURL = baseURL
            self.queryItems = queryItems
            self.path = path
            self.method = method
            self.body = body
            self.headers = headers
        }
    }
    
    func get(path: String, queryItems:[URLQueryItem], completion: @escaping (RHNetwork.HTTPClientResult) -> Void) {
        let request = Request(baseURL: domain, path: path, method: .get, queryItems: queryItems)
        client.request(with: request, completion: completion)
    }
    
    func post(path: String, body: [String: String]?, completion: @escaping (RHNetwork.HTTPClientResult) -> Void) {
        var request: RequestType
        if body != nil {
            guard let data = try? JSONSerialization.data(withJSONObject: body!, options: []) else {
                completion(.failure(.jsonToDataError))
                return
            }
            request = Request(baseURL: domain, path: path, method: .post, body: data)
        } else {
            request = Request(baseURL: domain, path: path, method: .post, body: nil)
        }
        client.request(with: request, completion: completion)
    }
    
    func download(path: String, completion: @escaping (HTTPClientResult) -> Void) {
        let request = Request(baseURL: domain, path: path, method: .download)
        client.request(with: request, completion: completion)
    }
}
