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
    var headers: [String : String]?
    let client: HTTPClient
    init(domain: URL, headers: [String : String]? = nil, client: HTTPClient=URLSessionHTTPClient()) {
        self.domain = domain
        self.headers = headers
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
        let request = Request(baseURL: domain, path: path, method: .get, queryItems: queryItems, headers: headers)
        client.request(with: request, completion: completion)
    }
    
    func post(path: String, body: [String: String]?, completion: @escaping (RHNetwork.HTTPClientResult) -> Void) {
        guard let body else {
            let request = Request(baseURL: domain, path: path, method: .post)
            client.request(with: request, completion: completion)
            return
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            let request = Request(baseURL: domain, path: path, method: .post, body: data)
            client.request(with: request, completion: completion)
            return
        } catch {
            completion(.failure(.jsonToDataError))
            return
        }
    }
}
