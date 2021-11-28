//
//  Types+Hashable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/1/21.
//

import Foundation

extension Type: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        switch self
        {
            case .literal(let type):
                hasher.combine(type)
            case .named(let type):
                hasher.combine(type)
            case .reference(let type):
                hasher.combine(type)
        }
    }
}

extension LiteralType: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        switch self
        {
            case .basic(let type):
                hasher.combine(type)
            case .cryptographic(let type):
                hasher.combine(type)
            case .choice(let type):
                hasher.combine(type)
            case .function(let type):
                hasher.combine(type)
            case .interfaceType(let type):
                hasher.combine(type)
            case .optional(let type):
                hasher.combine(type)
            case .selector(let type):
                hasher.combine(type)
            case .sequence(let type):
                hasher.combine(type)
            case .structure(let type):
                hasher.combine(type)
            case .tuple(let type):
                hasher.combine(type)
        }
    }
}

extension NamedReferenceType: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name)
    }
}

extension ReferenceType: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.identifier)
        hasher.combine(self.type)
    }
}

extension Choice: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name)
        for option in self.options
        {
            hasher.combine(option)
        }
    }
}

extension Option: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(name)
        for type in self.types
        {
            hasher.combine(type)
        }
    }
}

extension NamedFunction: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name)
        hasher.combine(self.signature)
    }
}

extension FunctionSignature: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        for parameter in self.parameters
        {
            hasher.combine(parameter)
        }

        if let result = self.result
        {
            hasher.combine(result)
        }
    }
}

extension Interface: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name)
        for function in self.functions
        {
            hasher.combine(function)
        }
    }
}

extension Optional: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.type)
    }
}

extension Selector: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name)
        hasher.combine(self.signature)
    }
}

extension Sequence: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.type)
    }
}

extension Structure: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name)
        for property in self.properties
        {
            hasher.combine(property)
        }
    }
}

extension Property: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name)
        hasher.combine(self.type)
    }
}

extension TupleType: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        for part in self.parts
        {
            hasher.combine(part)
        }
    }
}
