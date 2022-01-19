//
//  ReferenceArchive.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/3/21.
//

import Foundation
import Datable
import SwiftHexTools
import Gardener

public class ReferenceArchive: ReferenceStore
{
    let root: URL
    var nextIndex: UInt64

    public init?(path: String)
    {
        root = URL(fileURLWithPath: path)
        if !File.exists(path)
        {
            guard File.makeDirectory(atPath: path) else {return nil}
        }

        guard let contents = File.contentsOfDirectory(atPath: root.path) else {return nil}
        guard let maxKey = contents.max() else {return nil}
        guard let index: UInt64 = maxKey.data.maybeNetworkUint64 else {return nil}
        self.nextIndex = index
    }

    public var count: UInt64
    {
        return self.nextIndex
    }

    public func get(_ identifier: UInt64) -> Entity?
    {
        let name = identifier.maybeNetworkData!.hex
        let location = root.appendingPathComponent(name)
        guard let data = try? Data(contentsOf: location) else {return nil}
        guard let entity = Entity(data: data) else {return nil}
        return entity
    }

    public func put(_ identifier: UInt64, _ value: Entity) -> Bool
    {
        let name = identifier.maybeNetworkData!.hex
        let location = root.appendingPathComponent(name)
        let data = value.data

        do
        {
            try data.write(to: location)
        }
        catch
        {
            return false
        }

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
        guard let data = identifier.maybeNetworkData else {return false}
        let name = data.hex
        let location = root.appendingPathComponent(name)
        return File.delete(atPath: location.path)
    }
}
