//
//  Structure+Identifiable.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/6/21.
//

import Foundation

extension Structure: Identifiable
{
    public typealias ID = TypeIdentifier

    public var id: TypeIdentifier
    {
        return TypeIdentifier(identifier: self.name)
    }
}

public class TypeIdentifier: Codable, Equatable, Hashable
{
    public static func == (lhs: TypeIdentifier, rhs: TypeIdentifier) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }

    public let identifier: String

    public init(identifier: String)
    {
        self.identifier = identifier
    }

    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.identifier.data)
    }
}
