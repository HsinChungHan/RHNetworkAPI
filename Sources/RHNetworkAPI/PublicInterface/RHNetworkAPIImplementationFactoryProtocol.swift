//
//  RHNetworkAPIImplementationFactoryProtocol.swift
//
//
//  Created by Chung Han Hsin on 2024/1/24.
//

import Foundation
public protocol RHNetworkAPIImplementationFactoryProtocol {
    func makeRHNetworkAPIImplementation(with domain: URL) -> RHNetworkAPIProtocol
    func makeNonCacheRHNetworkAPIImplementation(with domain: URL) -> RHNetworkAPIProtocol
}
