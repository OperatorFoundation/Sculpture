//
//  NamedReferenceArchive.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/3/21.
//

import Foundation
import Gardener
import Datable
import SwiftHexTools

public class NamedReferenceArchive: NamedReferenceStore
{
    let root: URL

    public init?(path: String)
    {
        root = URL(fileURLWithPath: path)
        if !File.exists(path)
        {
            guard File.makeDirectory(atPath: path) else {return nil}
        }
    }

    public var count: UInt64
    {
        guard File.exists(self.root.path) else {return 0}
        guard let contents = File.contentsOfDirectory(atPath: self.root.path) else {return 0}
        return UInt64(contents.count)
    }

    public func get(_ name: String) -> Entity?
    {
        let location = root.appendingPathComponent(name.data.hex)
        guard let data = try? Data(contentsOf: location) else {return nil}
        guard let entity = Entity(data: data) else {return nil}
        return entity
    }

    public func put(_ name: String, _ value: Entity) -> Bool
    {
        let location = root.appendingPathComponent(name.data.hex)
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

    public func delete(_ name: String) -> Bool
    {
        let path = self.root.appendingPathComponent(name.data.hex)
        guard File.exists(path.path) else {return false}
        let success = File.delete(atPath: path.path)
        return success
    }
}
