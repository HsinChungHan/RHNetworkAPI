//
//  RHNetworkAPITests_EndToEndTests.swift
//
//
//  Created by Chung Han Hsin on 2024/1/25.
//

import XCTest
@testable import RHNetwork
@testable import RHNetworkAPI

class RHNetworkAPITests_EndToEndTests: XCTestCase {
    func test_request_matchesPokemonPikachuData() {
        if let receivedData = getPikachuData(),
            let json = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? [String: Any] {
            guard let pokemon_species = json["pokemon_species"] as? [[String: Any]] else {
                XCTFail("Expected pokemon_species, but got no pokemon_species!")
                return
            }
            XCTAssertEqual(pokemon_species.count, 51)
        }
    }
}

// MARK: - helpers
private extension RHNetworkAPITests_EndToEndTests {
    var baseURL: URL { .init(string: "https://pokeapi.co/api/v2")! }
    var path: String { "pokemon-color/1" }

    func getPikachuData(file: StaticString=#file, line: UInt=#line) -> Data? {
        let factory = RHNetworkAPIImplementationFactory()
        let networkAPI = factory.makeRHNetworkAPI(with: baseURL)
        var receivedData: Data?
        let exp = expectation(description: "wait for the response ...")
        networkAPI.get(path: path) { result in
            switch result {
            case let .success(data, _):
                receivedData = data
            default:
                XCTFail("Expected success, got \(result) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 30.0)
        return receivedData
    }
}
