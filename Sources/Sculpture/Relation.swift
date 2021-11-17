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
