//
//  Structure+Textable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/11/21.
//

import Foundation

public func parseInnerList<T>(structureText: StructureText) -> [T]? where T: Textable
{
    if let _ = structureText.line
    {
        return []
    }
    else if let block = structureText.block
    {
        let inner = block.inner
        return parseList(structureText: inner)
    }
    else
    {
        return nil
    }
}

public func parseList<T>(structureText: StructureText) -> [T]? where T: Textable
{
    if let _ = structureText.line
    {
        guard let item = T(structureText: structureText) else {return nil}
        return [item]
    }
    else if let _ = structureText.block
    {
        guard let item = T(structureText: structureText) else {return nil}
        return [item]
    }
    else if let list = structureText.list
    {
        let items = list.compactMap
        {
            (text: StructureText) -> T? in

            return T(structureText: text)
        }
        guard items.count == list.count else {return nil}

        return items
    }
    else
    {
        return nil
    }
}

extension Entity: Textable
{
    public init?(structureText: StructureText)
    {
        guard let block = structureText.block else {return nil}

        let name = block.line.name
        let inner = block.inner
        guard block.line.parameters.count == 0 else {return nil}

        switch name
        {
            case "type":
                guard let type = Type(structureText: inner) else {return nil}
                self = .type(type)
                return
            case "value":
                guard let value = Value(structureText: inner) else {return nil}
                self = .value(value)
                return
            case "flow":
                guard let flow = Flow(structureText: inner) else {return nil}
                self = .flow(flow)
                return
            default:
                return nil
        }
    }

    public var structureText: StructureText
    {
        switch self
        {
            case .type(let type):
                return .block(Block(
                    line: Line(name: "type", parameters: []),
                    inner: type.structureText
                ))
            case .value(let value):
                return .block(Block(
                    line: Line(name: "value", parameters: []),
                    inner: value.structureText
                ))
            case .flow(let flow):
                return .block(Block(
                    line: Line(name: "flow", parameters: []),
                    inner: flow.structureText
                ))
            case .relation(let relation):
                return .block(Block(
                    line: Line(name: "relation", parameters: []),
                    inner: relation.structureText
                ))
        }
    }
}
