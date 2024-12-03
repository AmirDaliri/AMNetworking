//
//  File.swift
//  Networking
//
//  Created by Amir Daliri.
//

import Foundation

public enum VoidResult<T: Error> {
    case success
    case failure(T)
}
