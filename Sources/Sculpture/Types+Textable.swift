//
//  Types+Textable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/11/21.
//

import Foundation

extension Type: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        switch self
        {
            case .literal(let type):
                return .block(Block(
                    line: Line(name: "literal", parameters: []),
                    inner: type.structureText
                ))
            case .named(let type):
                return .line(Line(name: "named", parameters: [type.name]))
            case .reference(let type):
                return .line(Line(name: "reference", parameters: [type.identifier.string]))
        }
    }
}

extension LiteralType: Textable
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
            case .interfaceType(let type):
                return .block(Block(
                    line: Line(name: "interface", parameters: []),
                    inner: type.structureText
                ))
            case .optional(let type):
                return .block(Block(
                    line: Line(name: "optional", parameters: []),
                    inner: type.structureText
                ))
            case .selector(let type):
                return .block(Block(
                    line: Line(name: "selector", parameters: []),
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

extension Choice: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        let list: [StructureText] = self.options.map
        {
            option in

            let typeList = option.types.map
            {
                type in

                return type.structureText
            }

            return .block(Block(
                line: Line(name: option.name, parameters: []),
                inner: .list(typeList)
            ))
        }

        return .block(Block(
            line: Line(name: "choice", parameters: [self.name]),
            inner: .list(list)
        ))
    }
}

extension FunctionSignature: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        let parameters: [StructureText] = self.parameters.map
        {
            parameter in

            return parameter.structureText
        }

        if let result = self.result
        {
            return .list([
                .block(Block(
                    line: Line(name: "function", parameters: []),
                    inner: .list(parameters)
                )),
                result.structureText
            ])
        }
        else
        {
            return .block(Block(
                line: Line(name: "function", parameters: []),
                inner: .list(parameters)
            ))
        }
    }
}

extension Interface: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        let list: [StructureText] = self.functions.map
        {
            function in

            return function.structureText
        }

        return .block(Block(
            line: Line(name: self.name, parameters: []),
            inner: .list(list)
        ))
    }
}

extension NamedFunction: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        return .block(Block(
            line: Line(name: "function", parameters: [self.name]),
            inner: self.signature.structureText
        ))
    }
}

extension Optional: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        return .block(Block(
            line: Line(name: "optional", parameters: []),
            inner: self.type.structureText
        ))
    }
}

extension Selector: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        return .block(Block(
            line: Line(name: "selector", parameters: []),
            inner: self.signature.structureText
        ))
    }
}

extension Sequence: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        return .block(Block(
            line: Line(name: "sequence", parameters: []),
            inner: self.type.structureText
        ))
    }
}

extension Structure: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        let list: [StructureText] = self.properties.map
        {
            property in

            return property.structureText
        }

        return .block(Block(
            line: Line(name: "structure", parameters: [self.name]),
            inner: .list(list)
        ))
    }
}

extension Property: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        return .block(Block(
            line: Line(name: "property", parameters: [self.name]),
            inner: self.type.structureText
        ))
    }
}

extension TupleType: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        let list: [StructureText] = self.parts.map
        {
            type in

            return type.structureText
        }

        return .block(Block(
            line: Line(name: "tuple", parameters: []),
            inner: .list(list)
        ))
    }
}
