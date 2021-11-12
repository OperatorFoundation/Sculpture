//
//  Values+Textable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/11/21.
//

import Foundation

extension Value: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        switch self
        {
            case .literal(let value):
                return .block(Block(
                    line: Line(name: "literal", parameters: []),
                    inner: value.structureText
                ))
            case .named(let value):
                return .line(Line(name: "named", parameters: [value.name]))
            case .reference(let value):
                return .line(Line(name: "reference", parameters: [value.identifier.string]))
        }
    }
}

extension LiteralValue: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        switch self
        {
            case .basic(let type):
                switch type
                {
                    case .int:
                        return .line(Line(name: "basic", parameters: ["int"]))
                    case .uint:
                        return .line(Line(name: "basic", parameters: ["uint"]))
                    case .string:
                        return .line(Line(name: "basic", parameters: ["string"]))
                }
            case .choice(let type):
                return .block(Block(
                    line: Line(name: "choice", parameters: []),
                    inner: type.structureText
                ))
            case .function(let type):
                return .block(Block(
                    line: Line(name: "function", parameters: []),
                    inner: type.structureText
                ))
            case .optional(let type):
                return .block(Block(
                    line: Line(name: "optional", parameters: []),
                    inner: type.structureText
                ))
            case .sequence(let type):
                return .block(Block(
                    line: Line(name: "sequence", parameters: []),
                    inner: type.structureText
                ))
            case .structure(let type):
                return .block(Block(
                    line: Line(name: "structure", parameters: []),
                    inner: type.structureText
                ))
            case .tuple(let type):
                return .block(Block(
                    line: Line(name: "tuple", parameters: []),
                    inner: type.structureText
                ))
        }
    }
}

extension OptionValue: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        let list: [StructureText] = self.values.map
        {
            value in

            return value.structureText
        }

        return .block(Block(
            line: Line(name: "choice", parameters: [self.choice, self.chosen]),
            inner: .list(list)
        ))
    }
}

extension Function: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        return .block(Block(
            line: Line(name: self.type, parameters: []),
            inner: .line(Line(name: self.body, parameters: []))
        ))
    }
}

extension SequenceValue: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        let list: [StructureText] = self.contents.map
        {
            value in

            return value.structureText
        }

        return .block(Block(
            line: Line(name: "sequence", parameters: [self.type]),
            inner: .list(list)
        ))
    }
}

extension StructureInstance: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        let list: [StructureText] = self.values.map
        {
            value in

            return value.structureText
        }

        return .block(Block(
            line: Line(name: "structure", parameters: [self.type]),
            inner: .list(list)
        ))
    }
}

extension Tuple: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        let list: [StructureText] = self.parts.map
        {
            value in

            return value.structureText
        }

        return .block(Block(
            line: Line(name: "tuple", parameters: []),
            inner: .list(list)
        ))
    }
}
