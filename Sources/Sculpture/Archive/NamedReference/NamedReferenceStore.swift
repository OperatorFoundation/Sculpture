//
//  NamedReferenceStore.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/3/21.
//

import Foundation

public protocol NamedReferenceStore
{
    func get(_ name: String) -> Entity?

    func put(_ name: String, _ value: Entity) -> Bool

    func delete(_ name: String) -> Bool

    var count: UInt64 {get}
}
