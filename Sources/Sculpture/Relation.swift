//
//  Relation.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/16/21.
//

import Foundation

public enum Relation: Codable, Equatable
{
    case inherits(Inherits)
    case implements(Implements)
    case encapsulates(Encapsulates)
}

extension Relation
{
    var left: Type
    {
        switch self
        {
            case .inherits(let relation):
                return relation.subclass
            case .implements(let relation):
                return relation.instance
            case .encapsulates(let relation):
                return relation.container
        }
    }

    var right: Type
    {
        switch self
        {
            case .inherits(let relation):
                return relation.superclass
            case .implements(let relation):
                return relation.interface
            case .encapsulates(let relation):
                return relation.item
        }
    }
}

public struct Inherits: Codable, Equatable
{
    public let subclass: Type
    public let superclass: Type

    public init(_ subclass: Type, _ superclass: Type)
    {
        self.subclass = subclass
        self.superclass = superclass
    }
}

public struct Implements: Codable, Equatable
{
    public let instance: Type
    public let interface: Type

    public init(_ instance: Type, _ interface: Type)
    {
        self.instance = instance
        self.interface = interface
    }
}

public struct Encapsulates: Codable, Equatable
{
    public let container: Type
    public let item: Type

    public init(_ container: Type, _ item: Type)
    {
        self.container = container
        self.item = item
    }
}
