//
//  Flow.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/27/21.
//

import Foundation

public enum Flow: Codable, Equatable
{
    case call(Call)
    case result(Result)
}

public struct Call: Codable, Equatable
{
    public let identifier: UInt64
    public let target: Value
    public let selector: Selector
    public let arguments: [Value]

    public init?(_ target: Value, _ selector: Selector, _ arguments: [Value])
    {
        self.identifier = CallDatabase.allocateIdentifier()
        self.target = target
        self.selector = selector
        self.arguments = arguments

        CallDatabase.put(call: self)
    }
}

public struct Result: Codable, Equatable
{
    public let identifier: UInt64
    public let type: Type
    public let value: Value
}

public class CallDatabase
{
    static var database: [UInt64: Call] = [:]
    static var nextIdentifier: UInt64 = 1

    static public func allocateIdentifier() -> UInt64
    {
        let identifier = nextIdentifier
        nextIdentifier = nextIdentifier + 1

        return identifier
    }

    static public func put(call: Call)
    {
        let identifier = call.identifier
        database[identifier] = call
    }

    static public func get(identifier: UInt64) -> Call?
    {
        return database[identifier]
    }
}
