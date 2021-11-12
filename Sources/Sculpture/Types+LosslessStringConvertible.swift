//
//  Types+LosslessStringConvertible.swift
//
//
//  Created by Dr. Brandon Wiley on 10/31/21.
//

import Foundation

extension Type: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}

extension LiteralType: CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}

extension Choice: CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}

extension FunctionSignature: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}

extension Interface: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}

extension NamedFunction: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}

extension Optional: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}

extension Selector: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}

extension Sequence: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}

extension Structure: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}

extension Property: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}

extension TupleType: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}
