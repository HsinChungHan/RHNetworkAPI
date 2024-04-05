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

public struct Request: RequestType {
    public var queryItems: [URLQueryItem]
    public var baseURL: URL
    public var path: String
    public var method: RHNetwork.HTTPMethod
    public var body: Data?
    public var headers: [String : String]?
    public init(baseURL: URL, path: String, method: RHNetwork.HTTPMethod, queryItems:[URLQueryItem]=[], body: Data? = nil, headers: [String : String]? = nil) {
        self.baseURL = baseURL
        self.queryItems = queryItems
        self.path = path
        self.method = method
        self.body = body
        self.headers = headers
    }
}

class RHNetworkAPIImplementation: RHNetworkAPIProtocol {
    let domain: URL
    var headers: [String : String]?
    private var client: HTTPClient
    init(domain: URL, headers: [String : String]? = nil, client: HTTPClient=URLSessionHTTPClient(configuration: .ephemeral, uploadDataTaskWithProgress: UrlsessionDataTaskWithProgress())) {
        self.domain = domain
        self.headers = headers
        self.client = client
    }
    
    func get(path: String, queryItems:[URLQueryItem], completion: @escaping (RHNetwork.HTTPClientResult) -> Void) {
        let request = Request(baseURL: domain, path: path, method: .get, queryItems: queryItems, headers: headers)
        client.request(with: request, completion: completion)
    }
    
    func get(with request: Request, completion: @escaping (RHNetwork.HTTPClientResult) -> Void) {
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
    
    func post(with request: Request, completion: @escaping (RHNetwork.HTTPClientResult) -> Void) {
        client.request(with: request, completion: completion)
    }
    
    func uploadDataTask(path: String, from data: Data?, completion: @escaping (RHNetwork.HTTPClientResult) -> Void, progressAction: ((Float) -> Void)? = nil) {
        let request = Request(baseURL: domain, path: path, method: .post)
        guard let progressAction else { return }
        client.registerProgressUpdate(for: request.fullURL.absoluteString, with: progressAction)
        client.uploadDataTaskWithProgress(with: request, from: data, completion: completion)
    }
    
    func uploadDataTask(with request: Request, from data: Data?, completion: @escaping (RHNetwork.HTTPClientResult) -> Void, progressAction: ((Float) -> Void)? = nil) {
        guard let progressAction else { return }
        client.registerProgressUpdate(for: request.fullURL.absoluteString, with: progressAction)
        client.uploadDataTaskWithProgress(with: request, from: data, completion: completion)
    }
}
