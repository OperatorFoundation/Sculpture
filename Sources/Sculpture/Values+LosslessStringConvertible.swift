//
//  Values+LosslessStringConvertible.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/11/21.
//

import Foundation

extension Value: LosslessStringConvertible, CustomStringConvertible
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

extension LiteralValue: LosslessStringConvertible, CustomStringConvertible
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

extension OptionValue: LosslessStringConvertible, CustomStringConvertible
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

extension Function: LosslessStringConvertible, CustomStringConvertible
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

extension SequenceValue: LosslessStringConvertible, CustomStringConvertible
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

extension StructureInstance: LosslessStringConvertible, CustomStringConvertible
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

extension Tuple: LosslessStringConvertible, CustomStringConvertible
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
