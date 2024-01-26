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
    func get(path: String, queryItems:[URLQueryItem], completion: @escaping (HTTPClientResult) -> Void)
    func post(path: String, body: [String:String]?, completion: @escaping (HTTPClientResult) -> Void) throws
    func download(path: String, completion: @escaping (HTTPClientResult) -> Void)
}
