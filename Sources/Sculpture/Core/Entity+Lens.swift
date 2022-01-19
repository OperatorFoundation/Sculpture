//
//  Entity+Lens.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/3/22.
//

import Foundation

public class EntityType
{
    var entity: Entity

    public init(_ entity: Entity)
    {
        self.entity = entity
    }

    public func get() -> Type?
    {
        switch self.entity
        {
            case .type(let type):
                return type
            default:
                return nil
        }
    }

    public func set(_ type: Type) -> Entity
    {
        self.entity = .type(type)
        return self.entity
    }
 }

public class EntityValue
{
    var entity: Entity

    public init(_ entity: Entity)
    {
        self.entity = entity
    }

    public func get() -> Value?
    {
        switch self.entity
        {
            case .value(let value):
                return value
            default:
                return nil
        }
    }

    public func set(_ value: Value) -> Entity
    {
        self.entity = .value(value)
        return self.entity
    }
}

public class EntityFlow
{
    var entity: Entity

    public init(_ entity: Entity)
    {
        self.entity = entity
    }

    public func get() -> Flow?
    {
        switch self.entity
        {
            case .flow(let flow):
                return flow
            default:
                return nil
        }
    }

    public func set(_ flow: Flow) -> Entity
    {
        self.entity = .flow(flow)
        return self.entity
    }
}

public class EntityRelation
{
    var entity: Entity

    public init(_ entity: Entity)
    {
        self.entity = entity
    }

    public func get() -> Relation?
    {
        switch self.entity
        {
            case .relation(let relation):
                return relation
            default:
                return nil
        }
    }

    public func set(_ relation: Relation) -> Entity
    {
        self.entity = .relation(relation)
        return self.entity
    }
}

extension Entity
{
    public var type: EntityType
    {
        return EntityType(self)
    }

    public var value: EntityValue
    {
        return EntityValue(self)
    }

    public var flow: EntityFlow
    {
        return EntityFlow(self)
    }

    public var relation: EntityRelation
    {
        return EntityRelation(self)
    }
}
