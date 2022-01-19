//
//  ReferenceMemoryStore.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/3/21.
//

import Foundation
import Datable
import SwiftHexTools
import Gardener

public class ReferenceMemoryStore: ReferenceStore
{
    var store: [UInt64: Entity] = [:]
    var nextIndex: UInt64 = 1

    public init()
    {
    }

    public var count: UInt64
    {
        return self.nextIndex
    }

    public func get(_ identifier: UInt64) -> Entity?
    {
        return self.store[identifier]
    }

    public func put(_ identifier: UInt64, _ value: Entity) -> Bool
    {
        self.store[identifier] = value
        return true
    }

    public func put(_ value: Entity) -> Bool
    {
        let identifier = nextIndex
        nextIndex += 1

        guard self.put(identifier, value) else {return false}
        return true
    }

    public func delete(_ identifier: UInt64) -> Bool
    {
        let _ = store.removeValue(forKey: identifier)
        return true
    }
}
