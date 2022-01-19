//
//  Clockwork+Format.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/26/21.
//

import Foundation

// FIXME
//extension Program
//{
//    public func format(options: FormatOptions = FormatOptions.`default`) -> Particle
//    {
//        if let name = self.name
//        {
//            if self.operations.count == 0
//            {
//                if options.shorthand
//                {
//                    return .compound([.atom(name+":"), .atom("∅")])
//                }
//                else
//                {
//                    return .compound([.atom(name+":"), .atom("nothing")])
//                }
//            }
//            else
//            {
//                let head: Particle = .atom(name+":")
//                let particles = self.operations.map
//                {
//                    (operation: Operation) -> Particle in
//
//                    return operation.particle
//                }
//
//                return .compound([head]+particles)
//            }
//        }
//        else
//        {
//
//        }
//
//        let name = self.name ?? ""
//
//        var type: String = ""
//        if self.operations.count == 0
//        {
//            if let input = self.input
//            {
//                type.append(input.type)
//            }
//            else
//            {
//                if options.shorthand
//                {
//                    return "∅"
//                }
//                else
//                {
//                    return "nothing"
//                }
//            }
//        }
//        else
//        {
//            if
//            let type = makeType(self.input, self.operations.last, self.allowedEvents, self.allowedEffects)
//        }
//    }
//}
//
//public struct FormatOptions
//{
//    static public let `default`: FormatOptions = FormatOptions(shorthand: false)
//
//    let shorthand: Bool
//
//    public init(shorthand: Bool)
//    {
//        self.shorthand = shorthand
//    }
//}
