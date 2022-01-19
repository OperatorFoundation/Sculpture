//
//  ParticleStore.swift
//
//
//  Created by Dr. Brandon Wiley on 12/3/21.
//

import Foundation

public typealias ParticleStoreLens = [Int]

public struct ParticleLens
{
    let path: ParticleStoreLens
    let store: ParticleStore

    public init(store: ParticleStore)
    {
        self.store = store

        self.path = store.root
    }

    public init(store: ParticleStore, path: ParticleStoreLens)
    {
        self.store = store
        self.path = path
    }

    public func get() -> Particle?
    {
        return self.store.get(path: self.path)
    }

    public func put(_ particle: Particle) -> Bool
    {
        return self.store.put(path: self.path, particle: particle)
    }

    public func count() -> Int
    {
        guard let particle = self.get() else {return 0}
        switch particle
        {
            case .atom(_):
                return 0
            case .compound(let particles):
                return particles.count
        }
    }

    public func isAtom() -> Bool
    {
        guard let particle = self.get() else {return false}
        switch particle
        {
            case .atom(_):
                return true
            case .compound(_):
                return false
        }
    }

    public func next() -> ParticleLens?
    {
        guard self.path.count > 0 else {return nil}
        guard let last = self.path.last else {return nil}
        let newPath = [Int](self.path.dropLast()) + [last + 1]
        let newLens = ParticleLens(store: self.store, path: newPath)
        guard let _ = newLens.get() else {return nil}
        return newLens
    }

    public func previous() -> ParticleLens?
    {
        guard self.path.count > 0 else {return nil}
        guard let last = self.path.last else {return nil}
        let newPath = [Int](self.path.dropLast()) + [last - 1]
        let newLens = ParticleLens(store: self.store, path: newPath)
        guard let _ = newLens.get() else {return nil}
        return newLens
    }

    public func descend() -> ParticleLens?
    {
        let newPath = self.path + [0]
        let newLens = ParticleLens(store: self.store, path: newPath)
        guard let _ = newLens.get() else {return nil}
        return newLens
    }

    public func ascend() -> ParticleLens?
    {
        let newPath = [Int](self.path.dropLast())
        let newLens = ParticleLens(store: self.store, path: newPath)
        guard let _ = newLens.get() else {return nil}
        return newLens
    }
}

public protocol ParticleStore
{
    var root: ParticleStoreLens {get}

    func get(path: ParticleStoreLens) -> Particle?
    func put(path: ParticleStoreLens, particle: Particle) -> Bool
    func count(path: ParticleStoreLens) -> Int
    func isAtom(path: ParticleStoreLens) -> Bool
}
