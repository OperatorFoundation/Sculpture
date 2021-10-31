////
////  File.swift
////  
////
////  Created by Dr. Brandon Wiley on 10/8/21.
////
//
//import Foundation
//
//public class TypeIdentifier: Codable, Equatable, Hashable
//{
//    public static func == (lhs: TypeIdentifier, rhs: TypeIdentifier) -> Bool
//    {
//        return lhs.identifier == rhs.identifier
//    }
//
//    public let identifier: String
//
//    public init(identifier: String)
//    {
//        self.identifier = identifier
//    }
//
//    public func hash(into hasher: inout Hasher)
//    {
//        hasher.combine(self.identifier.data)
//    }
//}
//
//extension LiteralType: Identifiable
//{
//    public typealias ID = TypeIdentifier
//
//    public var id: TypeIdentifier
//    {
//        switch self
//        {
//            case .basic(let type):
//                return type.id
//            case .choice(let type):
//                return type.id
//            case .structure(let type):
//                return type.id
//            case .sequence(let type):
//                return type.id
//            case .function(let type):
//                return type.id
//            case .selector(let type):
//                return type.id
//            case .interfaceType(let type):
//                return type.id
//            case .tuple(let type):
//                return type.id
//            case .optional(let id):
//                return type.id
//        }
//    }
//}
//
//extension BasicType: Identifiable
//{
//    public typealias ID = TypeIdentifier
//
//    public var id: TypeIdentifier
//    {
//        switch self
//        {
//            case .string:
//                return TypeIdentifier(identifier: "String")
//            case .uint:
//                return TypeIdentifier(identifier: "UInt")
//            case .int:
//                return TypeIdentifier(identifier: "Int")
//        }
//    }
//}
//
//extension Choice: Identifiable
//{
//    public typealias ID = TypeIdentifier
//
//    public var id: TypeIdentifier
//    {
//        return TypeIdentifier(identifier: self.name)
//    }
//}
//
//extension Structure: Identifiable
//{
//    public typealias ID = TypeIdentifier
//
//    public var id: TypeIdentifier
//    {
//        return TypeIdentifier(identifier: self.name)
//    }
//}
//
//extension Sequence: Identifiable
//{
//    public typealias ID = TypeIdentifier
//
//    public var id: TypeIdentifier
//    {
//        return TypeIdentifier(identifier: "[\(self.type)]")
//    }
//}
//
//extension ReferenceType: Identifiable
//{
//    public typealias ID = TypeIdentifier
//
//    public var id: TypeIdentifier
//    {
//        return TypeIdentifier(identifier: "\(self.identifier)")
//    }
//}
//
//extension NamedReferenceType: Identifiable
//{
//    public typealias ID = TypeIdentifier
//
//    public var id: TypeIdentifier
//    {
//        return TypeIdentifier(identifier: self.name)
//    }
//}
//
//extension FunctionSignature: Identifiable
//{
//    public typealias ID = TypeIdentifier
//
//    public var id: TypeIdentifier
//    {
//        if let result = self.result
//        {
//            let identifier = "func (\(parametersString)) -> \(resultString.description)"
//            return TypeIdentifier(identifier: identifier)
//        }
//        else
//        {
//            let identifier = "func (parametersString)"
//            return TypeIdentifier(identifier: identifier)
//        }
//    }
//}
