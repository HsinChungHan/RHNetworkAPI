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
        var baseURL: URL
        var path: String
        var method: RHNetwork.HTTPMethod
        var body: Data?
        var headers: [String : String]?
        init(baseURL: URL, path: String, method: RHNetwork.HTTPMethod, body: Data? = nil, headers: [String : String]? = nil) {
            self.baseURL = baseURL
            self.path = path
            self.method = method
            self.body = body
            self.headers = headers
        }
    }
    
    func get(path: String, completion: @escaping (RHNetwork.HTTPClientResult) -> Void) {
        let request = Request(baseURL: domain, path: path, method: .get)
        client.request(with: request, completion: completion)
    }
    
    func post(path: String, body: [String: String]?, completion: @escaping (RHNetwork.HTTPClientResult) -> Void) throws {
        do {
            let data = (body != nil) ? try JSONSerialization.data(withJSONObject: body!, options: []) : nil
            let request = Request(baseURL: domain, path: path, method: .post, body: data)
            client.request(with: request, completion: completion)
        } catch {
            throw RequestError.failedToTransferJsonToData
        }
    }
}
