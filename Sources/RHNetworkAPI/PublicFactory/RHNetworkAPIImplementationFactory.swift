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
    public func makeRHNetworkAPIImplementation(with domain: URL) -> RHNetworkAPIProtocol {
        return RHNetworkAPIImplementation(domain: domain)
    }
    
    public func makeNonCacheRHNetworkAPIImplementation(with domain: URL) -> RHNetworkAPIProtocol {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        return RHNetworkAPIImplementation(domain: domain, client: client)
    }
}
