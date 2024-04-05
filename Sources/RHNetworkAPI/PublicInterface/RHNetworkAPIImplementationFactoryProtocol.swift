//
//  RHNetworkAPIImplementationFactoryProtocol.swift
//
//
//  Created by Chung Han Hsin on 2024/1/24.
//

import Foundation
public protocol RHNetworkAPIImplementationFactoryProtocol {
    func makeCacheAndNoneUploadProgressClient(with domain: URL, headers: [String : String]?) -> RHNetworkAPIProtocol
    func makeNonCacheAndNoneUploadProgressClient(with domain: URL, headers: [String : String]?) -> RHNetworkAPIProtocol
    func makeNonCacheAndUploadProgressClient(with domain: URL, headers: [String : String]?) -> RHNetworkAPIProtocol
}
