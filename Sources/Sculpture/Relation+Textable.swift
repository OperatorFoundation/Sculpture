//
//  Relation+Textable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/16/21.
//

import Foundation

extension Relation: Textable
{
    public init?(structureText: StructureText)
    {
        guard let block = structureText.block else {return nil}
        let name = block.line.name

        switch name
        {
            case "implements":
                guard let relation = Implements(structureText: structureText) else {return nil}
                self = .implements(relation)
                return
            case "inherits":
                guard let relation = Inherits(structureText: structureText) else {return nil}
                self = .inherits(relation)
                return
            default:
                return nil
        }
    }

    public var structureText: StructureText
    {
        switch self
        {
            case .inherits(let inherits):
                return inherits.structureText
            case .implements(let implements):
                return implements.structureText
            case .encapsulates(let encapsulates):
                return encapsulates.structureText
        }
    }
}

extension Implements: Textable
{
    public init?(structureText: StructureText)
    {
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        guard name == "implements" else {return nil}

        let parameters = block.line.parameters
        guard parameters.count == 0 else {return nil}

        let inner = block.inner
        guard let types: [Type] = parseInnerList(structureText: inner) else {return nil}
        guard types.count == 2 else {return nil}
        self.instance = types[0]
        self.interface = types[1]
    }

    public var structureText: StructureText
    {
        return .block(Block(
            line: Line(name: "implements", parameters: []),
            inner: .list([
                instance.structureText,
                interface.structureText
            ])
        ))
    }
}

extension Inherits: Textable
{
    public init?(structureText: StructureText)
    {
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        guard name == "inherits" else {return nil}

        let parameters = block.line.parameters
        guard parameters.count == 0 else {return nil}

        let inner = block.inner
        guard let types: [Type] = parseInnerList(structureText: inner) else {return nil}
        guard types.count == 2 else {return nil}
        self.subclass = types[0]
        self.superclass = types[1]
    }

    public var structureText: StructureText
    {
        return .block(Block(
            line: Line(name: "inherits", parameters: []),
            inner: .list([
                subclass.structureText,
                superclass.structureText
            ])
        ))

    }
}

extension Encapsulates: Textable
{
    public init?(structureText: StructureText)
    {
        guard let block = structureText.block else {return nil}
        let name = block.line.name
        guard name == "encapsulates" else {return nil}

        let parameters = block.line.parameters
        guard parameters.count == 0 else {return nil}

        let inner = block.inner
        guard let types: [Type] = parseInnerList(structureText: inner) else {return nil}
        guard types.count == 2 else {return nil}
        self.container = types[0]
        self.item = types[1]
    }

    public var structureText: StructureText
    {
        return .block(Block(
            line: Line(name: "encapsulates", parameters: []),
            inner: .list([
                container.structureText,
                item.structureText
            ])
        ))

    }
}
