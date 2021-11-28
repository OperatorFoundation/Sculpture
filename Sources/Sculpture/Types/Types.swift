//
//  Types.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/6/21.
//

import Foundation

public indirect enum Type: Codable, Equatable
{
    case literal(LiteralType)
    case reference(ReferenceType)
    case named(NamedReferenceType)
}

public indirect enum LiteralType: Codable, Equatable
{
    case basic(BasicType)
    case structure(Structure)
    case sequence(Sequence)
    case choice(Choice)
    case function(FunctionSignature)
    case selector(Selector)
    case interfaceType(Interface)
    case tuple(TupleType)
    case optional(Optional)
    case cryptographic(CryptographicType)
}

public struct Structure: Codable, Equatable
{
    public let name: String
    public let properties: [Property]

    public init(_ name: String, _ properties: [Property])
    {
        self.name = name
        self.properties = properties
    }
}

public struct Property: Codable, Equatable
{
    public let name: String
    public let type: Type

    public init(_ name: String, type: Type)
    {
        self.name = name
        self.type = type
    }
}

//public indirect enum PropertyType: Codable, Equatable
//{
//    case basic(BasicType)
//    case structure(String)
//    case sequence(String)
//    case choice(String)
//}

public struct Sequence: Codable, Equatable
{
    public let type: Type

    public init(_ type: Type)
    {
        self.type = type
    }
}

public enum BasicType: Codable, Equatable
{
    case string
    case int
    case uint
    case bytes
    case boolean
}

public struct Choice: Codable, Equatable
{
    public let name: String
    public let options: [Option]

    public init(_ name: String, _ options: [Option])
    {
        self.name = name
        self.options = options
    }
}

public struct Option: Codable, Equatable
{
    public let name: String
    public let types: [Type]

    public init(_ name: String, _ types: [Type])
    {
        self.name = name
        self.types = types
    }
}

public struct FunctionSignature: Codable, Equatable
{
    public let parameters: [Type]
    public let result: Type?

    public init(_ parameters: [Type], _ result: Type?)
    {
        self.parameters = parameters
        self.result = result
    }
}

public struct NamedFunction: Codable, Equatable
{
    public let name: String
    public let signature: FunctionSignature

    public init(_ name: String, _ signature: FunctionSignature)
    {
        self.name = name
        self.signature = signature
    }
}

public struct Interface: Codable, Equatable
{
    public let name: String
    public let functions: [NamedFunction]

    public init(_ name: String, _ functions: [NamedFunction])
    {
        self.name = name
        self.functions = functions
    }
}

public struct TupleType: Codable, Equatable
{
    public let parts: [Type]

    public init(_ parts: [Type])
    {
        self.parts = parts
    }
}

public struct Optional: Codable, Equatable
{
    public let type: Type

    public init(_ type: Type)
    {
        self.type = type
    }
}

public class NamedTypeDatabase
{
    static var database: [String: Type] = [:]

    static public func put(name: String, type: Type)
    {
        database[name] = type
    }

    static public func get(name: String) -> Type?
    {
        return database[name]
    }
}

public class TypeDatabase
{
    static var database: [UInt64: Type] = [:]
    static var nextIdentifier: UInt64 = 1

    static public func put(type: Type) -> UInt64
    {
        let identifier = nextIdentifier
        nextIdentifier = nextIdentifier + 1

        database[identifier] = type

        return identifier
    }

    static public func get(identifier: UInt64) -> Type?
    {
        return database[identifier]
    }
}

public struct NamedReferenceType: Codable, Equatable
{
    public let name: String
//    public var type: Type?
//    {
//        return NamedTypeDatabase.get(name: self.name)
//    }

    public init(_ name: String)
    {
//        guard let _ = NamedTypeDatabase.get(name: name) else { return nil }
        self.name = name
    }

//    public init(_ name: String, _ type: Type)
//    {
//        self.name = name
//
//        NamedTypeDatabase.put(name: name, type: type)
//    }
}

public struct ReferenceType: Codable, Equatable
{
    public let identifier: UInt64
    public var type: Type?
    {
        return TypeDatabase.get(identifier: identifier)
    }

    public init?(_ identifier: UInt64)
    {
        guard let _ = TypeDatabase.get(identifier: identifier) else { return nil }
        self.identifier = identifier
    }

    public init(_ identifier: UInt64, _ type: Type)
    {
        self.identifier = TypeDatabase.put(type: type)
    }
}

public struct Selector: Codable, Equatable
{
    public let name: String
    public let signature: FunctionSignature

    public init(_ name: String, signature: FunctionSignature)
    {
        self.name = name
        self.signature = signature
    }
}
