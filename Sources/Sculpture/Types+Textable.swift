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
        if let line = structureText.line
        {
            let name = line.name
            let parameters = line.parameters
            switch name
            {
                case "named":
                    guard parameters.count == 1 else {return nil}
                    let typeName = parameters[0]
                    self = .named(NamedReferenceType(typeName))
                    return
                case "reference":
                    guard parameters.count == 1 else {return nil}
                    let typeIdentifierString = parameters[0]
                    let typeIdentifier = UInt64(string: typeIdentifierString)
                    guard let reference = ReferenceType(typeIdentifier) else {return nil}
                    self = .reference(reference)
                    return
                default:
                    return nil
            }
        }
        else if let block = structureText.block
        {
            let line = block.line
            let inner = block.inner
            let name = line.name
            let parameters = line.parameters

            guard name == "literal" else {return nil}
            guard parameters.count == 0 else {return nil}

            guard let type = LiteralType(structureText: inner) else {return nil}
            self = .literal(type)
        }
        else
        {
            return nil
        }
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
        if let line = structureText.line
        {
            let name = line.name
            let parameters = line.parameters

            guard name == "basic" else {return nil}
            guard parameters.count == 1 else {return nil}

            let typeString = parameters[0]

            switch typeString
            {
                case "int":
                    self = .basic(.int)
                    return
                case "uint":
                    self = .basic(.uint)
                    return
                case "string":
                    self = .basic(.string)
                    return
                default:
                    return nil
            }
        }
        else if let block = structureText.block
        {
            let name = block.line.name
            let parameters = block.line.parameters
            let inner = block.inner

            switch name
            {
                case "choice":
                    guard parameters.count == 0 else {return nil}
                    guard let type = Choice(structureText: inner) else {return nil}
                    self = .choice(type)
                    return
                case "function":
                    guard parameters.count == 0 else {return nil}
                    guard let type = FunctionSignature(structureText: inner) else {return nil}
                    self = .function(type)
                    return
                case "interface":
                    guard parameters.count == 0 else {return nil}
                    guard let type = Interface(structureText: inner) else {return nil}
                    self = .interfaceType(type)
                    return
                case "optional":
                    guard parameters.count == 0 else {return nil}
                    guard let type = Optional(structureText: inner) else {return nil}
                    self = .optional(type)
                    return
                case "selector":
                    guard parameters.count == 0 else {return nil}
                    guard let type = Selector(structureText: inner) else {return nil}
                    self = .selector(type)
                    return
                case "sequence":
                    guard parameters.count == 0 else {return nil}
                    guard let type = Sequence(structureText: inner) else {return nil}
                    self = .sequence(type)
                    return
                case "structure":
                    guard parameters.count == 0 else {return nil}
                    guard let type = Structure(structureText: inner) else {return nil}
                    self = .structure(type)
                    return
                case "tuple":
                    guard parameters.count == 0 else {return nil}
                    guard let type = TupleType(structureText: inner) else {return nil}
                    self = .tuple(type)
                    return
                default:
                    return nil
            }
        }
        else
        {
            return nil
        }
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
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        let paramaeters = block.line.parameters
        let inner = block.inner

        guard paramaeters.count == 1 else {return nil}
        guard let list = inner.list else {return nil}

        let options = list.compactMap
        {
            (text: StructureText) -> Option? in

            guard let block = text.block else {return nil}
            let name = block.line.name
            let parameters = block.line.parameters
            let inner = block.inner

            guard parameters.count == 0 else {return nil}

            guard let list = inner.list else {return nil}
            let types = list.compactMap
            {
                (text: StructureText) -> Type? in

                return Type(structureText: text)
            }
            guard types.count == list.count else {return nil}

            return Option(name, types)
        }

        guard options.count == list.count else {return nil}

        self = Choice(name, options)
        return
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
        if let list = structureText.list
        {
            guard list.count == 2 else {return nil}
            guard let parametersBlock = list[0].block else {return nil}
            let resultText = list[1]

            let name = parametersBlock.line.name
            guard name == "function" else {return nil}

            guard parametersBlock.line.parameters.count == 0 else {return nil}
            let inner = parametersBlock.inner

            guard let parametersList = inner.list else {return nil}
            let parameters = parametersList.compactMap
            {
                (parameterText: StructureText) -> Type? in

                return Type(structureText: parameterText)
            }

            guard parameters.count == parametersList.count else {return nil}

            guard let resultType = Type(structureText: resultText) else {return nil}

            self = FunctionSignature(parameters, resultType)
            return
        }
        else if let parametersBlock = structureText.block
        {
            let name = parametersBlock.line.name
            guard name == "function" else {return nil}

            guard parametersBlock.line.parameters.count == 0 else {return nil}
            let inner = parametersBlock.inner

            guard let parametersList = inner.list else {return nil}
            let parameters = parametersList.compactMap
            {
                (parameterText: StructureText) -> Type? in

                return Type(structureText: parameterText)
            }

            guard parameters.count == parametersList.count else {return nil}

            self = FunctionSignature(parameters, nil)
            return
        }
        else
        {
            return nil
        }
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
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        guard name == "interface" else {return nil}

        let parameters = block.line.parameters
        guard parameters.count == 1 else {return nil}
        let interfaceName = parameters[0]

        let inner = block.inner
        guard let list = inner.list else {return nil}

        let functions = list.compactMap
        {
            (text: StructureText) -> NamedFunction? in

            return NamedFunction(structureText: text)
        }
        guard functions.count == list.count else {return nil}

        self = Interface(interfaceName, functions)
        return
    }

    var structureText: StructureText
    {
        let list: [StructureText] = self.functions.map
        {
            function in

            return function.structureText
        }

        return .block(Block(
            line: Line(name: "interface", parameters: [self.name]),
            inner: .list(list)
        ))
    }
}

extension NamedFunction: Textable
{
    init?(structureText: StructureText)
    {
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        guard name == "function" else {return nil}

        let parameters = block.line.parameters
        guard parameters.count == 1 else {return nil}
        let functionName = parameters[0]

        let inner = block.inner
        guard let signature = FunctionSignature(structureText: inner) else {return nil}

        self = NamedFunction(functionName, signature)
        return
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
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        guard name == "optional" else {return nil}

        let parameters = block.line.parameters
        guard parameters.count == 0 else {return nil}

        let inner = block.inner
        guard let type = Type(structureText: inner) else {return nil}

        self = Optional(type)
        return
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
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        guard name == "sequence" else {return nil}

        let parameters = block.line.parameters
        guard parameters.count == 0 else {return nil}

        let inner = block.inner
        guard let type = Type(structureText: inner) else {return nil}
        self = Sequence(type)
        return
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
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        guard name == "structure" else {return nil}

        let parameters = block.line.parameters
        guard parameters.count == 1 else {return nil}
        let structureName = parameters[0]

        let inner = block.inner
        guard let list = inner.list else {return nil}

        let properties = list.compactMap
        {
            (text: StructureText) -> Property? in

            return Property(structureText: text)
        }
        guard properties.count == list.count else {return nil}

        self = Structure(structureName, properties)
        return
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
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        guard name == "property" else {return nil}

        let parameters = block.line.parameters
        guard parameters.count == 1 else {return nil}
        let propertyName = parameters[0]

        let inner = block.inner
        guard let type = Type(structureText: inner) else {return nil}

        self = Property(propertyName, type: type)
        return
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
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        guard name == "tuple" else {return nil}

        let parameters = block.line.parameters
        guard parameters.count == 0 else {return nil}

        let inner = block.inner
        guard let list = inner.list else {return nil}

        let parts = list.compactMap
        {
            (text: StructureText) -> Type? in

            return Type(structureText: text)
        }
        guard parts.count == list.count else {return nil}

        self = TupleType(parts)
        return
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
