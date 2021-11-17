//
//  Swift.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/1/21.
//

import Foundation
import Sculpture

public func entitySource(entity: Entity) -> String
{
    switch entity
    {
        case .type(let type):
            return typeSource(type: type)
        case .value(let value):
            return valueSource(value: value)
        case .flow(let flow):
            return flowSource(flow: flow)
        case .relation(let relation):
            return relationSource(relation)
    }
}

public func typeSource(type: Type) -> String
{
    switch type
    {
        case .literal(let literal):
            return literalTypeSource(literal: literal)
        case .named(let named):
            return named.name
        case .reference(let reference):
            // FIXME
            return "FIXME"
    }
}

public func valueSource(value: Value) -> String
{
    return ""
}

public func flowSource(flow: Flow) -> String
{
    return ""
}

public func literalTypeSource(literal: LiteralType) -> String
{
    switch literal
    {
        case .basic(let basic):
            return basicTypeSource(basic: basic)
        case .choice(let choice):
            return choiceSource(choice: choice)
        case .function(let function):
            return functionSignatureSource(function: function)
        case .interfaceType(let i):
            return interfaceSource(i)
        case .optional(let optional):
            return optionalSource(optional)
        case .selector(let selector):
            return selectorSource(selector)
        case .sequence(let sequence):
            return sequenceSource(sequence)
        case .structure(let structure):
            return structureSource(structure)
        case .tuple(let tuple):
            return tupleSource(tuple)
    }
}

public func basicTypeSource(basic: BasicType) -> String
{
    switch basic
    {
        case .int:
            return "Int"
        case .string:
            return "String"
        case .uint:
            return "UInt"
    }
}

public func choiceSource(choice: Choice) -> String
{
    return """
    enum \(choice.name)
    {
      \(optionsSource(options: choice.options))
    }
    """
}

public func optionsSource(options: [Option]) -> String
{
    let strings = options.map
    {
        option in

        return optionSource(option: option)
    }

    return strings.joined(separator: "\n")
}

public func optionSource(option: Option) -> String
{
    if option.types.count > 0
    {
        return "case \(option.name)(\(typesSource(types: option.types))"
    }
    else
    {
        return "case \(option.name)"
    }
}

public func typesSource(types: [Type]) -> String
{
    let strings = types.map
    {
        type in

        return typeSource(type: type)
    }

    return strings.joined(separator: ", ")
}

public func functionSignatureSource(function: FunctionSignature) -> String
{
    if let result = function.result
    {
        return "(\(parametersSource(function.parameters))) -> \(typeSource(type: result))"
    }
    else
    {
        return "(\(parametersSource(function.parameters)))"
    }
}

public func parametersSource(_ parameters: [Type]) -> String
{
    let strings = parameters.map
    {
        type in

        return typeSource(type: type)
    }

    return strings.joined(separator: ", ")
}

public func interfaceSource(_ i: Interface) -> String
{
    return """
    protocol \(i.name)
    {
      \(interfaceFunctionsSource(i.functions))
    }
    """
}

public func interfaceFunctionsSource(_ functions: [NamedFunction]) -> String
{
    let strings = functions.map
    {
        type in

        return namedFunctionSource(type)
    }

    return strings.joined(separator: "\n")
}

public func namedFunctionSource(_ function: NamedFunction) -> String
{
    return "func \(function.name)\(functionSignatureSource(function: function.signature))"
}

public func optionalSource(_ optional: Optional) -> String
{
    return "\(typeSource(type: optional.type))?"
}

public func selectorSource(_ selector: Sculpture.Selector) -> String
{
    return "\(selector.name)\(selector.signature)"
}

public func sequenceSource(_ sequence: Sequence) -> String
{
    return "[\(typeSource(type: sequence.type))]"
}

public func structureSource(_ structure: Structure) -> String
{
    let strings = structure.properties.map
    {
        type in

        return "let \(type.name): \(type.type)"
    }

    let propertiesString = strings.joined(separator: "\n")

    return """
    struct \(structure.name)
    {
      \(propertiesString)
    }
    """
}

public func tupleSource(_ tuple: TupleType) -> String
{
    let strings = tuple.parts.map
    {
        type in

        return typeSource(type: type)
    }

    let partsString = strings.joined(separator: ", ")
    return "(\(partsString))"
}

public func relationSource(_ relation: Relation) -> String
{
    // FIXME
    return ""
}
