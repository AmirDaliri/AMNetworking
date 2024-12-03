//
//  HTTPParameterTests.swift
//  Networking
//
//  Created by Amir Daliri.
//

import XCTest
@testable import Networking

final class HTTPParameterTests: XCTestCase {
    
    func testInitialization() {
        let key = "param_key"
        let value = "param_value"
        let parameter = HTTPParameter(key: key, value: value)
        
        XCTAssertEqual(parameter.key, key)
        XCTAssertEqual(parameter.value, value)
    }
    
}
