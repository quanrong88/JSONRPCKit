//
//  AnyEncodable.swift
//  JSONRPCKit
//
//  Created by Olli Tapaninen on 20/08/2018.
//  Copyright © 2018 Shinichiro Oba. All rights reserved.
//

import Foundation

/// Type erasure wrapper for making heterogenous arrays/sets encodable.
/// See https://forums.swift.org/t/how-to-encode-objects-of-unknown-type/12253/11
/// By the way, this implementation works with DateEncodingStrategy, see Unit Tests
public struct AnyEncodable: Encodable {
    private let encodingFunc: (inout SingleValueEncodingContainer) throws -> Void

    public init<T: Encodable>(_ value: T) {
        self.encodingFunc = { (container: inout SingleValueEncodingContainer) in
            try value.encode(to: &container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try encodingFunc(&container)
    }
}

extension Encodable {
    fileprivate func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}

//public struct AnyEncodable: Encodable {
//    private let value: Any
//
//    public init<T>(_ value: T?) {
//        self.value = value ?? ()
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        try (value as! Encodable).encode(to: encoder)
//    }
//}
