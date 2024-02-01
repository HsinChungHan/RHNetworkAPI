//
//  RHNetworkAPIImplementationFactory.swift
//
//
//  Created by Chung Han Hsin on 2024/1/24.
//

import Foundation
import RHNetwork

public struct RHNetworkAPIImplementationFactory: RHNetworkAPIImplementationFactoryProtocol {
    public init() {}
    public func makeCacheClient(with domain: URL, headers: [String : String]? = nil) -> RHNetworkAPIProtocol {
        RHNetworkAPIImplementation(domain: domain)
    }
    
    public func makeNonCacheClient(with domain: URL, headers: [String : String]? = nil) -> RHNetworkAPIProtocol {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        return RHNetworkAPIImplementation(domain: domain, client: client)
    }
}
