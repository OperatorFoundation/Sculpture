//
//  Structure+Focus.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/13/21.
//

import Foundation
import Focus

//extension Entity
//{
//    public var type: SimplePrism<Entity, Type>
//    {
//        SimplePrism<Entity, Type>(
//            tryGet:
//            {
//                (entity: Entity) -> Type? in
//
//                switch entity
//                {
//                    case .type(let type):
//                        return type
//                    default:
//                        return nil
//                }
//            },
//
//            inject:
//            {
//                (type: Type) -> Entity in
//
//                return .type(type)
//            }
//        )
//    }
//
//    public var value: SimplePrism<Entity, Value>
//    {
//        SimplePrism<Entity, Value>(
//            tryGet:
//                {
//                    (entity: Entity) -> Value? in
//
//                    switch entity
//                    {
//                        case .value(let value):
//                            return value
//                        default:
//                            return nil
//                    }
//                },
//
//            inject:
//                {
//                    (value: Value) -> Entity in
//
//                    return .value(value)
//                }
//        )
//    }
//
//    public var flow: SimplePrism<Entity, Flow>
//    {
//        SimplePrism<Entity, Flow>(
//            tryGet:
//                {
//                    (entity: Entity) -> Flow? in
//
//                    switch entity
//                    {
//                        case .flow(let flow):
//                            return flow
//                        default:
//                            return nil
//                    }
//                },
//
//            inject:
//                {
//                    (flow: Flow) -> Entity in
//
//                    return .flow(flow)
//                }
//        )
//    }
//
//    public var relation: SimplePrism<Entity, Relation>
//    {
//        SimplePrism<Entity, Relation>(
//            tryGet:
//                {
//                    (entity: Entity) -> Relation? in
//
//                    switch entity
//                    {
//                        case .relation(let relation):
//                            return relation
//                        default:
//                            return nil
//                    }
//                },
//
//            inject:
//                {
//                    (relation: Relation) -> Entity in
//
//                    return .relation(relation)
//                }
//        )
//    }
//}
