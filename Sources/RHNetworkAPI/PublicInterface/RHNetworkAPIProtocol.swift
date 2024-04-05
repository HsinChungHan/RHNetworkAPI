//
//  RHNetworkAPIProtocol.swift
//
//
//  Created by Chung Han Hsin on 2024/1/24.
//

import Foundation
import RHNetwork

public protocol RHNetworkAPIProtocol {
    var domain: URL { get }
    var headers: [String:String]? { get }
    func get(path: String, queryItems: [URLQueryItem], completion: @escaping (HTTPClientResult) -> Void)
    func get(with request: Request, completion: @escaping (RHNetwork.HTTPClientResult) -> Void)
    func post(path: String, body: [String:String]?, completion: @escaping (HTTPClientResult) -> Void) throws
    func post(with request: Request, completion: @escaping (RHNetwork.HTTPClientResult) -> Void)
    func uploadDataTask(path: String, from data: Data?, completion: @escaping (RHNetwork.HTTPClientResult) -> Void, progressAction: ((Float) -> Void)?)
    func uploadDataTask(with request: Request, from data: Data?, completion: @escaping (RHNetwork.HTTPClientResult) -> Void, progressAction: ((Float) -> Void)?)
}
