//
//  RHNetworkAPIImplementationFactoryProtocol.swift
//
//
//  Created by Chung Han Hsin on 2024/1/24.
//

import Foundation
public protocol RHNetworkAPIImplementationFactoryProtocol {
    func makeRHNetworkAPI(with domain: URL) -> RHNetworkAPIProtocol
}
