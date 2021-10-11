//
//  Values.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/6/21.
//

import Foundation

public enum Value: Codable, Equatable
{
    case basic(BasicValue)
    case structure(StructureInstance)
    case sequence(SequenceValue)
    case choice(OptionValue)
}

public enum BasicValue: Codable, Equatable
{
    case string(String)
    case int(Int64)
    case uint(UInt64)
}

public struct StructureInstance: Codable, Equatable
{
    public let type: String
    public let values: [PropertyValue]

    public init(_ type: String, values: [PropertyValue])
    {
        self.type = type
        self.values = values
    }
}

public enum PropertyValue: Codable, Equatable
{
    case basic(BasicValue)
    case structure(StructureInstance)
    case sequence([PropertyValue])
    case choice(OptionValue)
    case reference(ReferenceValue)
}

public struct OptionValue: Codable, Equatable
{
    public let choice: String
    public let chosen: String
    public let values: [PropertyValue]

    public init(_ choice: String, _ chosen: String, _ values: [PropertyValue])
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

public struct ReferenceValue: Codable, Equatable
{
    public let name: String

    public init(_ name: String)
    {
        self.name = name
    }
}
