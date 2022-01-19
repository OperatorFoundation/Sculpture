//
//  ReferenceStore.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/3/21.
//

import Foundation

public protocol ReferenceStore
{
    func get(_ identifier: UInt64) -> Entity?

    func put(_ identifier: UInt64, _ value: Entity) -> Bool
    func put(_ value: Entity) -> Bool

    func delete(_ identifier: UInt64) -> Bool

    var count: UInt64 {get}
}
