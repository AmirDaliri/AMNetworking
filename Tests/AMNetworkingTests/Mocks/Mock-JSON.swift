//
//  Mock-JSON.swift
//  Networking
//
//  Created by Amir Daliri.
//

import Foundation

let mockPersonJsonData = """
{
    "name": "John",
    "age": 30
}
""".data(using: .utf8)!

let invalidMockPersonJsonData = """
{
    "Name": "John",
    "Age": 30
}
""".data(using: .utf8)!
