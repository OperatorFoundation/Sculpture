//
//  Eval.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/25/21.
//

import Foundation

extension Program
{
    public func eval(context: Context) -> (Entity?, [Event], [Effect])
    {
        if let input = self.input
        {
            if self.operations.count == 0
            {
                return (input, [], [])
            }

            let result = self.operations.reduce(input)
            {
                (partialResult: Entity?, operation: Operation) -> Entity? in

                switch operation
                {
                    case .function(let clockworkFunction):
                        guard let partialResult = partialResult else {return nil}
                        let (result, _, _) = clockworkFunction.implementation(partialResult)
                        return result
                    default:
                        // FIXME
                        return partialResult
                }
            }

            return (result, [], [])
        }
        else
        {
            guard self.operations.count > 0 else {return (nil, [], [])}

            let first = self.operations[0]
            let rest = [Operation](self.operations[1...])

            switch first
            {
                case .data(let cwdata):
                    let data = self.eval(data: cwdata, context: context)
                    let program = Program(input: data, operations: rest, allowedEvents: [], allowedEffects: [])
                    return program.eval(context: context)
                default:
                    // First operation must be a data constructor
                    return (nil, [], [])
            }
        }
    }

    public func eval(data: ClockworkData, context: Context) -> Entity?
    {
        switch data
        {
            case .atom(let entity):
                return entity
            case .constructor(let f):
                //FIXME
                return nil
            case .expression(let e):
                //FIXME
                return nil
        }
    }
}
