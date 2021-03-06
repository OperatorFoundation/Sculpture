//
//  Values+Textable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/11/21.
//

import Foundation
import Datable
import SwiftHexTools

extension Value: Textable
{
    public init?(structureText: StructureText)
    {
        if let line = structureText.line
        {
            let name = line.name
            let parameters = line.parameters

            switch name
            {
                case "named":
                    guard parameters.count == 1 else {return nil}
                    let referenceName = parameters[0]
                    self = .named(NamedReferenceValue(referenceName))
                    return
                case "reference":
                    guard parameters.count == 1 else {return nil}
                    let identifierString = parameters[0]
                    let identifier = UInt64(string: identifierString)
                    guard let reference = ReferenceValue(identifier) else {return nil}
                    self = .reference(reference)
                    return
                default:
                    return nil
            }
        }
        else if let block = structureText.block
        {
            let name = block.line.name
            guard name == "literal" else {return nil}

            let parameters = block.line.parameters
            guard parameters.isEmpty else {return nil}

            let inner = block.inner
            guard let value = LiteralValue(structureText: inner) else {return nil}

            self = .literal(value)
            return
        }
        else
        {
            return nil
        }
    }

    public var structureText: StructureText
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
    public init?(structureText: StructureText)
    {
        if let line = structureText.line
        {
            let name = line.name
            switch name
            {
                case "int":
                    let parameters = line.parameters
                    guard parameters.count == 1 else {return nil}
                    let valueString = parameters[0]
                    let value = Int64(string: valueString)
                    self = .basic(BasicValue.int(value))
                    return
                case "uint":
                    let parameters = line.parameters
                    guard parameters.count == 1 else {return nil}
                    let valueString = parameters[0]
                    let value = UInt64(string: valueString)
                    self = .basic(BasicValue.uint(value))
                    return
                case "string":
                    let parameters = line.parameters
                    guard parameters.count == 1 else {return nil}
                    guard let data = Data(hex: parameters[0]) else {return nil}
                    let value = data.string
                    self = .basic(BasicValue.string(value))
                    return
                case "bytes":
                    let parameters = line.parameters
                    guard parameters.count == 1 else {return nil}
                    guard let data = Data(hex: parameters[0]) else {return nil}
                    self = .basic(BasicValue.bytes(data))
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
                    guard let value = OptionValue(structureText: inner) else {return nil}
                    self = .choice(value)
                    return
                case "function":
                    guard parameters.count == 0 else {return nil}
                    guard let value = Function(structureText: inner) else {return nil}
                    self = .function(value)
                    return
                case "optional":
                    guard parameters.count == 0 else {return nil}
                    guard let value = Optional(structureText: inner) else {return nil}
                    self = .optional(value)
                    return
                case "sequence":
                    guard parameters.count == 0 else {return nil}
                    guard let value = SequenceValue(structureText: inner) else {return nil}
                    self = .sequence(value)
                    return
                case "structure":
                    guard parameters.count == 0 else {return nil}
                    guard let value = StructureInstance(structureText: inner) else {return nil}
                    self = .structure(value)
                    return
                case "tuple":
                    guard parameters.count == 0 else {return nil}
                    guard let value = Tuple(structureText: inner) else {return nil}
                    self = .tuple(value)
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

    public var structureText: StructureText
    {
        switch self
        {
            case .basic(let type):
                switch type
                {
                    case .int(let value):
                        return .line(Line(name: "int", parameters: [value.string]))
                    case .uint(let value):
                        return .line(Line(name: "uint", parameters: [value.string]))
                    case .string(let value):
                        return .line(Line(name: "string", parameters: [value.data.hex]))
                    case .bytes(let value):
                        return .line(Line(name: "bytes", parameters: [value.data.hex]))
                    case .boolean(let value):
                        switch value
                        {
                            case true:
                                return .line(Line(name: "boolean", parameters: ["true"]))
                            case false:
                                return .line(Line(name: "boolean", parameters: ["false"]))
                        }
                    case .float(let value):
                        return .line(Line(name: "float", parameters: [value.description]))
                }
            case .cryptographic(let type):
                switch type
                {
                    case .p256AgreementPublic(let value):
                        return .line(Line(name: "p256AgreementPublic", parameters: [value.data.hex]))
                    case .p256AgreementPrivate(let value):
                        return .line(Line(name: "p256AgreementPrivate", parameters: [value.data.hex]))
                    case .p256SigningPublic(let value):
                        return .line(Line(name: "p256SigningPublic", parameters: [value.data.hex]))
                    case .p256SigningPrivate(let value):
                        return .line(Line(name: "p256SigningPrivate", parameters: [value.data.hex]))
                    case .p256Signature(let value):
                        return .line(Line(name: "p256Signature", parameters: [value.data.hex]))
                    case .sha256(let value):
                        return .line(Line(name: "sha256", parameters: [value.hex]))
                    case .chaChaPolyKey(let value):
                        return .line(Line(name: "chaChaPolyKey", parameters: [value.data.hex]))
                    case .chaChaPolyNonce(let value):
                        return .line(Line(name: "chaChaPolyNonce", parameters: [value.data.hex]))
                    case .chaChaPolyBox(let value):
                        return .line(Line(name: "chaChaPolyBox", parameters: [value.data.hex]))
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
    public init?(structureText: StructureText)
    {
        if let line = structureText.line
        {
            let name = line.name
            guard name == "choice" else {return nil}

            let parameters = line.parameters
            guard parameters.count == 2 else {return nil}

            let choiceName = parameters[0]
            let chosen = parameters[1]

            self = OptionValue(choiceName, chosen, [])
            return
        }
        else if let block = structureText.block
        {
            let name = block.line.name
            guard name == "choice" else {return nil}

            let parameters = block.line.parameters
            guard parameters.count == 2 else {return nil}

            let choiceName = parameters[0]
            let chosen = parameters[1]

            guard let values: [Value] = parseInnerList(structureText: structureText) else {return nil}

            self = OptionValue(choiceName, chosen, values)
            return
        }
        else
        {
            return nil
        }
    }

    public var structureText: StructureText
    {
        let list: [StructureText] = self.values.map
        {
            value in

            return value.structureText
        }

        switch list.count
        {
            case 0:
                return .line(Line(name: "choice", parameters: [self.choice, self.chosen]))
            case 1:
                return .block(Block(
                    line: Line(name: "choice", parameters: [self.choice, self.chosen]),
                    inner: list[0]
                ))
            default:
                return .block(Block(
                    line: Line(name: "choice", parameters: [self.choice, self.chosen]),
                    inner: .list(list)
                ))
        }
    }
}

extension Function: Textable
{
    public init?(structureText: StructureText)
    {
        guard let block = structureText.block else {return nil}
        let type = block.line.name

        let parameters = block.line.parameters
        guard parameters.isEmpty else {return nil}

        let inner = block.inner
        guard let bodyLine = inner.line else {return nil}

        let bodyName = bodyLine.name
        let bodyParameters = bodyLine.parameters
        guard bodyParameters.isEmpty else {return nil}

        self = Function(type, bodyName)
        return
    }

    public var structureText: StructureText
    {
        return .block(Block(
            line: Line(name: self.type, parameters: []),
            inner: .line(Line(name: self.body, parameters: []))
        ))
    }
}

extension SequenceValue: Textable
{
    public init?(structureText: StructureText)
    {
        if let line = structureText.line
        {
            let name = line.name
            guard name == "sequence" else {return nil}

            let parameters = line.parameters
            guard parameters.count == 1 else {return nil}
            let type = parameters[0]

            self = SequenceValue(type, [])
            return
        }
        else if let block = structureText.block
        {
            let name = block.line.name
            guard name == "sequence" else {return nil}

            let parameters = block.line.parameters
            guard parameters.count == 1 else {return nil}
            let type = parameters[0]

            guard let contents: [Value] = parseInnerList(structureText: structureText) else {return nil}

            self = SequenceValue(type, contents)
            return
        }
        else
        {
            return nil
        }
    }

    public var structureText: StructureText
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
    public init?(structureText: StructureText)
    {
        if let line = structureText.line
        {
            let name = line.name
            guard name == "structure" else {return nil}

            let parameters = line.parameters
            guard parameters.count == 1 else {return nil}
            let type = parameters[0]

            self = StructureInstance(type, values: [])
            return
        }
        else if let block = structureText.block
        {
            let name = block.line.name
            guard name == "structure" else {return nil}

            let parameters = block.line.parameters
            guard parameters.count == 1 else {return nil}
            let type = parameters[0]

            guard let values: [Value] = parseInnerList(structureText: structureText) else {return nil}

            self = StructureInstance(type, values: values)
            return
        }
        else
        {
            return nil
        }
    }

    public var structureText: StructureText
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
    public init?(structureText: StructureText)
    {
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        guard name == "tuple" else {return nil}

        let parameters = block.line.parameters
        guard parameters.isEmpty else {return nil}

        let inner = block.inner
        guard let list = inner.list else {return nil}
        guard list.count == 2 else {return nil}

        let typeText = list[0]
        let partsText = list[1]

        guard let type = Type(structureText: typeText) else {return nil}
        guard let partsList = partsText.list else {return nil}

        let parts = partsList.compactMap
        {
            (text: StructureText) -> Value? in

            return Value(structureText: text)
        }
        guard parts.count == list.count else {return nil}

        self = Tuple(type, parts)
        return
    }

    public var structureText: StructureText
    {
        let list: [StructureText] = self.parts.map
        {
            value in

            return value.structureText
        }

        return .block(Block(
            line: Line(name: "tuple", parameters: []),
            inner: .list([
                self.type.structureText,
                .block(Block(line: Line(name: "parts", parameters: []), inner: .list(list)))
            ])
        ))
    }
}
