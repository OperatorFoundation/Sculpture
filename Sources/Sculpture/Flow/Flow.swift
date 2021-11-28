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

    public init?(identifier: UInt64, _ target: Value, _ selector: Selector, _ arguments: [Value])
    {
        self.identifier = identifier
        self.target = target
        self.selector = selector
        self.arguments = arguments
    }

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
    public let value: ResultValue

    public init(_ identifier: UInt64, _ value: ResultValue)
    {
        self.identifier = identifier
        self.value = value
    }
}

public enum ResultValue: Codable, Equatable
{
    case value(Value)
    case failure
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

    static public func delete(identifier: UInt64)
    {
        database.removeValue(forKey: identifier)
    }
}

public typealias FunctionImplementation = (Value?, [Value]) -> Value?

public struct InterfaceImplementation
{
    let interface: Interface
    let functions: [NamedFunction: FunctionImplementation]

    public init(_ interface: Interface, _ functions: [NamedFunction: FunctionImplementation])
    {
        self.interface = interface
        self.functions = functions
    }

    public func select(_ selector: Selector) -> FunctionImplementation?
    {
        for (function, implementation) in self.functions
        {
            if function.name == selector.name && function.signature == selector.signature
            {
                return implementation
            }
        }

        return nil
    }
}
