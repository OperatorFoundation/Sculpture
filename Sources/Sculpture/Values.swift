//
//  Values.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/6/21.
//

import Foundation

public indirect enum Value: Codable, Equatable
{
    case literal(LiteralValue)
    case named(NamedReferenceValue)
    case reference(ReferenceValue)
}


public enum LiteralValue: Codable, Equatable
{
    case basic(BasicValue)
    case choice(OptionValue)
    case function(Function)
    case optional(Optional)
    case sequence(SequenceValue)
    case structure(StructureInstance)
    case tuple(Tuple)
}

public enum BasicValue: Codable, Equatable
{
    case int(Int64)
    case string(String)
    case uint(UInt64)
}

public struct StructureInstance: Codable, Equatable
{
    public let type: String
    public let values: [Value]

    public init(_ type: String, values: [Value])
    {
        self.type = type
        self.values = values
    }
}

//public enum PropertyValue: Codable, Equatable
//{
//    case basic(BasicValue)
//    case structure(StructureInstance)
//    case sequence([PropertyValue])
//    case choice(OptionValue)
//    case function(Function)
//    case tuple(Tuple)
//    case optional(Optional)
//    case reference(ReferenceValue)
//}

public struct OptionValue: Codable, Equatable
{
    public let choice: String
    public let chosen: String
    public let values: [Value]

    public init(_ choice: String, _ chosen: String, _ values: [Value])
    {
        self.choice = choice
        self.chosen = chosen
        self.values = values
    }
}

public struct SequenceValue: Codable, Equatable
{
    public let type: String
    public let contents: [Value]

    public init(_ type: String, _ contents: [Value])
    {
        self.type = type
        self.contents = contents
    }
}

public struct Function: Codable, Equatable
{
    public let type: String
    public let body: String

    public init(_ type: String, _ body: String)
    {
        self.type = type
        self.body = body
    }
}

public struct Tuple: Codable, Equatable
{
    public let type: Type
    public let parts: [Value]
    public let size: Int

    public init(_ type: Type, _ parts: [Value])
    {
        self.type = type
        self.parts = parts
        self.size = self.parts.count
    }
}

public enum OptionalValue: Codable, Equatable
{
    case value(Value)
    case empty
}

public class NamedValueDatabase
{
    static var database: [String: LiteralValue] = [:]

    static public func put(name: String, value: LiteralValue)
    {
        database[name] = value
    }

    static public func get(name: String) -> LiteralValue?
    {
        return database[name]
    }
}

public class ValueDatabase
{
    static var database: [UInt64: LiteralValue] = [:]
    static var nextIdentifier: UInt64 = 1

    static public func put(value: LiteralValue) -> UInt64
    {
        let identifier = nextIdentifier
        nextIdentifier = nextIdentifier + 1

        database[identifier] = value

        return identifier
    }

    static public func get(identifier: UInt64) -> LiteralValue?
    {
        return database[identifier]
    }
}


public struct NamedReferenceValue: Codable, Equatable
{
    public let name: String
    public var value: LiteralValue?
    {
        return NamedValueDatabase.get(name: self.name)
    }

    public init?(_ name: String)
    {
        guard let _ = NamedValueDatabase.get(name: name) else { return nil }
        self.name = name
    }

    public init(_ name: String, _ value: LiteralValue)
    {
        self.name = name

        NamedValueDatabase.put(name: name, value: value)
    }
}

public struct ReferenceValue: Codable, Equatable
{
    public let identifier: UInt64
    public var value: LiteralValue?
    {
        return ValueDatabase.get(identifier: identifier)
    }

    public init?(_ identifier: UInt64)
    {
        guard let _ = ValueDatabase.get(identifier: identifier) else { return nil }
        self.identifier = identifier
    }

    public init(_ identifier: UInt64, _ value: LiteralValue)
    {
        self.identifier = ValueDatabase.put(value: value)
    }
}
