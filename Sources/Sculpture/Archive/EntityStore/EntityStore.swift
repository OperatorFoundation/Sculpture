//
//  File.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/3/22.
//

import Foundation

public typealias EntityStoreLens = [Int]

public struct EntityLens
{
    let path: EntityStoreLens
    let store: EntityStore

    public init(store: EntityStore)
    {
        self.store = store

        self.path = store.root
    }

    public init(store: EntityStore, path: EntityStoreLens)
    {
        self.store = store
        self.path = path
    }

    public func get() -> Entity?
    {
        return self.store.get(path: self.path)
    }

    public func put(_ entity: Entity) -> Bool
    {
        return self.store.put(path: self.path, entity: entity)
    }

    public func next() -> EntityLens?
    {
        guard self.path.count > 0 else {return nil}
        guard let last = self.path.last else {return nil}
        let newPath = [Int](self.path.dropLast()) + [last + 1]
        let newLens = EntityLens(store: self.store, path: newPath)
        guard let _ = newLens.get() else {return nil}
        return newLens
    }

    public func previous() -> EntityLens?
    {
        guard self.path.count > 0 else {return nil}
        guard let last = self.path.last else {return nil}
        let newPath = [Int](self.path.dropLast()) + [last - 1]
        let newLens = EntityLens(store: self.store, path: newPath)
        guard let _ = newLens.get() else {return nil}
        return newLens
    }

    public func descend() -> EntityLens?
    {
        let newPath = self.path + [0]
        let newLens = EntityLens(store: self.store, path: newPath)
        guard let _ = newLens.get() else {return nil}
        return newLens
    }

    public func ascend() -> EntityLens?
    {
        let newPath = [Int](self.path.dropLast())
        let newLens = EntityLens(store: self.store, path: newPath)
        guard let _ = newLens.get() else {return nil}
        return newLens
    }
}

public protocol EntityStore
{
    var root: EntityStoreLens {get}

    func get(path: EntityStoreLens) -> Entity?
    func put(path: EntityStoreLens, entity: Entity) -> Bool
}
