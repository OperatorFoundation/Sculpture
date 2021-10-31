////
////  Types+CustomStringConvertible.swift
////  
////
////  Created by Dr. Brandon Wiley on 10/31/21.
////
//
//import Foundation
//
//extension Type: CustomStringConvertible
//{
//    public var description: String
//    {
//        switch self
//        {
//            case .literal(let type):
//                return type.description
//            case .reference(let type):
//                return type.identifier.description
//            case .named(let type):
//                return type.name
//        }
//    }
//}
//
//extension LiteralType: CustomStringConvertible
//{
//    public var description: String
//    {
//        switch self
//        {
//            case .basic(let type):
//                return type.description
//            case .choice(let type):
//                return type.description
//            case .function(let type):
//                return type.description
//            case .interfaceType(let type):
//                return type.description
//            case .optional(let type):
//                return type.description
//            case .selector(let type):
//                return type.description
//            case .sequence(let type):
//                return type.description
//            case .structure(let type):
//                return type.description
//            case .tuple(let type):
//                return type.type
//        }
//    }
//}
//
//extension BasicType: CustomStringConvertible
//{
//    public var description: String
//    {
//        switch self
//        {
//            case .string:
//                return "string"
//            case .int:
//                return "int"
//            case .uint:
//                return "uint"
//        }
//    }
//}
//
//extension Choice: CustomStringConvertible
//{
//    public var description: String
//    {
//        let optionsParts = options.map
//        {
//            option in
//
//            return option.description
//        }
//        let optionsString = optionsParts.componentsJoined(by: ", ")
//        return "Choice(\(self.name), \(optionsString))"
//    }
//}
//
//extension Option: CustomStringConvertible
//{
//    public var description: String
//    {
//        let parts = types.map
//        {
//            part in
//
//            return part.description
//        }
//        let typesString = parts.componentsJoined(by: ", ")
//        return "Option(\(self.name), \(typesString))"
//    }
//}
//
//extension PropertyType: CustomStringConvertible
//{
//    public var description: String
//    {
//        let parts = types.map
//        {
//            part in
//
//            return part.description
//        }
//        let typesString = parts.componentsJoined(by: ", ")
//        return "Option(\(self.name), \(typesString))"
//    }
//}
