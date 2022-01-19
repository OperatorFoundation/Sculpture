//
//  NamedReferenceMemoryStore.swift
//
//
//  Created by Dr. Brandon Wiley on 12/3/21.
//

import Foundation
import Gardener

public class NamedReferenceMemoryStore: NamedReferenceStore
{
    var store: [String: Entity] = [:]

    public var count: UInt64
    {
        return UInt64(self.store.count)
    }

    public init()
    {
    }

    public func get(_ name: String) -> Entity?
    {
        return store[name]
    }

    public func put(_ name: String, _ value: Entity) -> Bool
    {
        store[name] = value
        return true
    }

    public func delete(_ name: String) -> Bool
    {
        self.store.removeValue(forKey: name)
        return true
    }
}
