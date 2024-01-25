//
//  RHNetworkAPIImplementationFactory.swift
//
//
//  Created by Chung Han Hsin on 2024/1/24.
//

import Foundation
public struct RHNetworkAPIImplementationFactory: RHNetworkAPIImplementationFactoryProtocol {
    public init() {}
    public func makeRHNetworkAPI(with domain: URL) -> RHNetworkAPIProtocol {
        return RHNetworkAPIImplementation(domain: domain)
    }
}
