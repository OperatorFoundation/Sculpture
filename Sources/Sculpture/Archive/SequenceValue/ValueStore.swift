//
//  ValueStore.swift
//
//
//  Created by Dr. Brandon Wiley on 12/3/21.
//

import Foundation

// Stores an append-only sequence of anonymous Values
public protocol ValueStore
{
    func put(_ value: Value) -> Bool

    // Sequence
    associatedtype Iterator: IteratorProtocol
    associatedtype Element where Self.Element == Self.Iterator.Element
    func makeIterator() -> Self.Iterator
}
