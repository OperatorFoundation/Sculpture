//
//  Relation+Hashable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/16/21.
//

import Foundation

extension Relation: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        switch self
        {
            case .implements(let relation):
                hasher.combine(relation)
            case .inherits(let relation):
                hasher.combine(relation)
        }
    }
}

extension Inherits: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine("inherits")
        hasher.combine(self.subclass)
        hasher.combine(self.superclass)
    }
}

extension Implements: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine("implements")
        hasher.combine(self.instance)
        hasher.combine(self.interface)
    }
}
