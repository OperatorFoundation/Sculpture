//
//  ValueMemoryStore.swift
//
//
//  Created by Dr. Brandon Wiley on 12/3/21.
//

import Foundation
import Datable
import SwiftHexTools
import Gardener

public class ValueMemoryStore: ValueStore
{
    public typealias Element = Value
    public typealias Iterator = ValueMemoryStoreIterator

    var store: [Value] = []

    public init()
    {
    }

    public func put(_ value: Value) -> Bool
    {
        self.store.append(value)
        return true
    }

    // Sequence
    public func makeIterator() -> ValueMemoryStoreIterator
    {
        return ValueMemoryStoreIterator(self.store)
    }
}

public class ValueMemoryStoreIterator: IteratorProtocol
{
    public typealias Element = Value

    var store: [Value]
    var currentIndex: Int = 0

    public init(_ store: [Value])
    {
        self.store = store
    }

    // Iterator
    public func next() -> Element?
    {
        if self.currentIndex < self.store.count
        {
            let result = self.store[self.currentIndex]
            self.currentIndex += 1
            return result
        }
        else
        {
            return nil
        }
    }
}
