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
        // FIXME
        return nil
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
