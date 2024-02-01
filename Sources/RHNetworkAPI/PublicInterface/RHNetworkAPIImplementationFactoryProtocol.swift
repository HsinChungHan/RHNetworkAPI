//
//  RHNetworkAPIImplementationFactoryProtocol.swift
//
//
//  Created by Chung Han Hsin on 2024/1/24.
//

import Foundation
public protocol RHNetworkAPIImplementationFactoryProtocol {
    func makeCacheClient(with domain: URL, headers: [String : String]?) -> RHNetworkAPIProtocol
    func makeNonCacheClient(with domain: URL, headers: [String : String]?) -> RHNetworkAPIProtocol
}
