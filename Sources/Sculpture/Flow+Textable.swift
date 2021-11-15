//
//  File.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/11/21.
//

import Foundation

extension Flow: Textable
{
    public init?(structureText: StructureText)
    {
        if let list = structureText.list
        {
            guard list.count == 3 else {return nil}
            let call = list[0]
            let selectorText = list[1]
            let argumentsText = list[2]

            guard let block = call.block else {return nil}
            let name = block.line.name
            guard name == "call" else {return nil}

            let paramaters = block.line.parameters
            guard paramaters.count == 1 else {return nil}
            let identifierString = paramaters[0]
            let identifier = UInt64(string: identifierString)

            let inner = block.inner
            guard let target = Value(structureText: inner) else {return nil}

            guard let selector = Selector(structureText: selectorText) else {return nil}

            guard let argumentsBlock = argumentsText.block else {return nil}
            let argumentsName = argumentsBlock.line.name
            guard argumentsName == "arguments" else {return nil}

            let argumentsParameters = argumentsBlock.line.parameters
            guard argumentsParameters.isEmpty else {return nil}

            let argumentsInner = argumentsBlock.inner
            guard let list = argumentsInner.list else {return nil}

            let arguments = list.compactMap
            {
                (text: StructureText) -> Value? in

                return Value(structureText: text)
            }
            guard arguments.count == list.count else {return nil}

            guard let call = Call(identifier: identifier, target, selector, arguments) else {return nil}
            self = .call(call)
            return
        }
        else if let block = structureText.block
        {
            let name = block.line.name
            guard name == "result" else {return nil}

            let parameters = block.line.parameters
            guard parameters.count == 1 else {return nil}
            let identifierString = parameters[0]
            let identifier = UInt64(string: identifierString)

            let inner = block.inner
            if let line = inner.line
            {
                let name = line.name
                let parameters = line.parameters

                if name == "failure"
                {
                    guard parameters.isEmpty else {return nil}
                    let resultValue: ResultValue = .failure
                    self = .result(Result(identifier, resultValue))
                    return
                }
                else
                {
                    guard let value = Value(structureText: inner) else {return nil}
                    let resultValue: ResultValue = .value(value)
                    self = .result(Result(identifier, resultValue))
                    return
                }
            }
            else
            {
                guard let value = Value(structureText: inner) else {return nil}
                let resultValue: ResultValue = .value(value)
                self = .result(Result(identifier, resultValue))
                return
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
