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

public struct Inherits: Codable, Equatable
{
    let subclass: Type
    let superclass: Type

    public init(_ subclass: Type, _ superclass: Type)
    {
        self.subclass = subclass
        self.superclass = superclass
    }
}

public struct Implements: Codable, Equatable
{
    let instance: Type
    let interface: Type

    public init(_ instance: Type, _ interface: Type)
    {
        self.instance = instance
        self.interface = interface
    }
}

public struct Encapsulates: Codable, Equatable
{
    let container: Type
    let item: Type

    public init(_ container: Type, _ item: Type)
    {
        self.container = container
        self.item = item
    }
}
