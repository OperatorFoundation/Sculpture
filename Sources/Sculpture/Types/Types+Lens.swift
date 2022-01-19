//
//  File.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/3/22.
//

import Foundation

extension Type
{
    public var literal: TypeLiteral
    {
        return TypeLiteral(self)
    }

    public var named: TypeNamedReferenceType
    {
        return TypeNamedReferenceType(self)
    }

    public var reference: TypeReferenceType?
    {
        return TypeReferenceType(self)
    }
}

extension EntityType
{
    public var literal: EntityTypeLiteralType
    {
        return EntityTypeLiteralType(self)
    }

    public var reference: EntityTypeReferenceType
    {
        return EntityTypeReferenceType(self)
    }

    public var named: EntityTypeNamedReferenceType
    {
        return EntityTypeNamedReferenceType(self)
    }
}

public class TypeLiteral
{
    var type: Type

    public init(_ type: Type)
    {
        self.type = type
    }

    public func get() -> LiteralType?
    {
        switch type
        {
            case .literal(let literal):
                return literal
            default:
                return nil
        }
    }

    public func set(_ literal: LiteralType) -> Type
    {
        return .literal(literal)
    }
}

public class TypeReferenceType
{
    var type: Type

    public init(_ type: Type)
    {
        self.type = type
    }

    public func get() -> ReferenceType?
    {
        switch type
        {
            case .reference(let reference):
                return reference
            default:
                return nil
        }
    }

    public func set(_ reference: ReferenceType) -> Type
    {
        return .reference(reference)
    }
}

public class TypeNamedReferenceType
{
    var type: Type

    public init(_ type: Type)
    {
        self.type = type
    }

    public func get() -> NamedReferenceType?
    {
        switch type
        {
            case .named(let named):
                return named
            default:
                return nil
        }
    }

    public func set(_ named: NamedReferenceType) -> Type
    {
        return .named(named)
    }
}

public class EntityTypeLiteralType
{
    var type: EntityType

    public init(_ type: EntityType)
    {
        self.type = type
    }

    public func get() -> LiteralType?
    {
        guard let type = self.type.get() else {return nil}
        switch type
        {
            case .literal(let literal):
                return literal
            default:
                return nil
        }
    }

    public func set(_ literal: LiteralType) -> Entity?
    {
        return self.type.set(.literal(literal))
    }
}

public class EntityTypeReferenceType
{
    var type: EntityType

    public init(_ type: EntityType)
    {
        self.type = type
    }

    public func get() -> ReferenceType?
    {
        guard let type = self.type.get() else {return nil}
        switch type
        {
            case .reference(let reference):
                return reference
            default:
                return nil
        }
    }

    public func set(_ reference: ReferenceType) -> Entity?
    {
        return self.type.set(.reference(reference))
    }
}

public class EntityTypeNamedReferenceType
{
    var type: EntityType

    public init(_ type: EntityType)
    {
        self.type = type
    }

    public func get() -> NamedReferenceType?
    {
        guard let type = self.type.get() else {return nil}
        switch type
        {
            case .named(let named):
                return named
            default:
                return nil
        }
    }

    public func set(_ named: NamedReferenceType) -> Entity?
    {
        return self.type.set(.named(named))
    }
}

