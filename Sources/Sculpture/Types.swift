//
//  Types.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/6/21.
//

import Foundation

public indirect enum Type: Codable, Equatable
{
    case basic(BasicType)
    case structure(Structure)
    case sequence(Sequence)
    case choice(Choice)
    case reference(ReferenceType)
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
    public let type: PropertyType

    public init(_ name: String, type: PropertyType)
    {
        self.name = name
        self.type = type
    }
}

public indirect enum PropertyType: Codable, Equatable
{
    case basic(BasicType)
    case structure(String)
    case sequence(String)
    case choice(String)
}

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
    public let types: [PropertyType]

    public init(_ name: String, _ types: [PropertyType])
    {
        self.name = name
        self.types = types
    }
}

public struct ReferenceType: Codable, Equatable
{
    public let name: String

    public init(_ name: String)
    {
        self.name = name
    }
}
