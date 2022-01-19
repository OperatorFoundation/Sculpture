//
//  Clockwork.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/25/21.
//

import Foundation

// Data constructor functions
// Data transformation functions
// Operators on functions

// Main event
// Return effect

// Compie time / runtime arbitrary tagged types

public class Clockwork
{
    public init()
    {
    }

    public func parse(string: String, context: Context) -> Program?
    {
        guard let text = StructureText(string) else {return nil}
        guard let particle = text.particle else {return nil}

        switch particle
        {
            case .atom(let atom):
                guard let operation = context.get(atom) else {return nil}
                switch operation
                {
                    case .data(_):
                        return Program(input: nil, operations: [operation], allowedEvents: [], allowedEffects: [])
                    default:
                        // First operation must be a data constructor
                        return nil
                }
            case .compound(let compoound):
                guard compoound.count > 0 else {return nil}

                let operations = compoound.compactMap
                {
                    (particle: Particle) -> Operation? in

                    switch particle
                    {
                        case .atom(let atom):
                            return context.get(atom)
                        case .compound(_):
                            // FIXME
                            return nil
                    }
                }
                guard operations.count == compoound.count else {return nil}

                let first = operations[0]

                switch first
                {
                    case .data(_):
                        return Program(input: nil, operations: operations, allowedEvents: [], allowedEffects: [])
                    default:
                        // First operation must be a data constructor
                        return nil
                }
        }
    }
}

public struct Program
{
    let name: String?
    let input: Entity?
    let operations: [Operation]
    let allowedEvents: [Type]
    let allowedEffects: [Type]

    public init(name: String? = nil, input: Entity?, operations: [Operation], allowedEvents: [Type], allowedEffects: [Type])
    {
        self.name = name
        self.input = input
        self.operations = operations
        self.allowedEvents = allowedEvents
        self.allowedEffects = allowedEffects
    }
}

public enum Operation
{
    case data(ClockworkData)
    case function(ClockworkFunction)
    case `operator`(ClockworkOperator)
}

public struct ClockworkFunction
{
    let name: String
    let shorthand: String?
    let implementation: (Entity) -> (Entity?, [Event], [Effect])

    public init(_ name: String, _ shorthand: String? = nil, _ implementation: @escaping (Entity) -> (Entity?, [Event], [Effect]))
    {
        self.name = name
        self.shorthand = shorthand
        self.implementation = implementation
    }
}

public struct ClockworkOperator
{
    let name: String
    let shorthand: String?
    let implementation: (ClockworkFunction, Entity?) -> ClockworkFunction

    public init(_ name: String, _ shorthand: String? = nil, _ implementation: @escaping (ClockworkFunction, Entity?) -> ClockworkFunction)
    {
        self.name = name
        self.shorthand = shorthand
        self.implementation = implementation
    }
}

public struct Event
{
    let name: String
    let handler: ClockworkFunction

    public init(_ name: String, _ handler: ClockworkFunction)
    {
        self.name = name
        self.handler = handler
    }
}

public struct Effect
{
    let name: String
    let value: Entity

    public init(_ name: String, _ value: Entity)
    {
        self.name = name
        self.value = value
    }
}

public class Context
{
    var map: [String: Operation]

    public init()
    {
        self.map = [:]
    }

    public init(_ map: [String: Operation])
    {
        self.map = map
    }

    public func put(_ string: String, _ value: Operation)
    {
        self.map[string] = value
    }

    public func get(_ string: String) -> Operation?
    {
        return self.map[string]
    }
}

public enum ClockworkData
{
    case atom(Entity)
    case constructor(ClockworkConstructorFunction)
    case expression(ClockworkConstructorExpression)
}

public struct ClockworkConstructorFunction
{
    let name: String
    let shorthand: String?
    let implementation: (Context) -> Entity

    public init(_ name: String, _ shorthand: String? , _ implementation: @escaping (Context) -> Entity)
    {
        self.name = name
        self.shorthand = shorthand
        self.implementation = implementation
    }
}

public struct ClockworkConstructorExpression
{
    let name: String
    let shorthand: String?
    let implementation: (Context, [ClockworkData]) -> Entity?

    public init(_ name: String, _ shorthand: String? , _ implementation: @escaping (Context, [ClockworkData]) -> Entity?)
    {
        self.name = name
        self.shorthand = shorthand
        self.implementation = implementation
    }
}
