//
//  Structure+Textable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/11/21.
//

import Foundation

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
        }
    }
}
