//
//  incr.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/26/21.
//

import Foundation

let incr = ClockworkFunction("incr", "++")
{
    (entity: Entity) -> (Entity?, [Event], [Effect]) in

    switch entity
    {
        case .value(let value):
            switch value
            {
                case .literal(let literal):
                    switch literal
                    {
                        case .basic(let basic):
                            switch basic
                            {
                                case .int(let int):
                                    return (.value(.literal(.basic(.int(int+1)))), [], [])
                                default:
                                    return (nil, [], [])
                            }
                        default:
                            return (nil, [], [])
                    }
                default:
                    return (nil, [], [])
            }
        default:
            return (nil, [], [])
    }
}
