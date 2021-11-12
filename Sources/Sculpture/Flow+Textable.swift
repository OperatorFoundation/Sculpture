//
//  File.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/11/21.
//

import Foundation

extension Flow: Textable
{
    init?(structureText: StructureText)
    {
        return nil
    }

    var structureText: StructureText
    {
        switch self
        {
            case .call(let flow):
                let list = flow.arguments.map
                {
                    value in

                    return value.structureText
                }

                return .list([
                    .block(Block(
                        line: Line(name: "call", parameters: [flow.identifier.string]),
                        inner: flow.target.structureText
                    )),
                    flow.selector.structureText,
                    .block(Block(
                        line: Line(name: "arguments", parameters: []),
                        inner: .list(list)
                    ))
                ])

            case .result(let flow):
                switch flow.value
                {
                    case .value(let result):
                        return .block(Block(
                            line: Line(name: "result", parameters: [flow.identifier.string]),
                            inner: result.structureText
                        ))
                    case .failure:
                        return .block(Block(
                            line: Line(name: "result", parameters: [flow.identifier.string]),
                            inner: .line(Line(name: "failure", parameters: []))
                        ))
                }
        }
    }
}
