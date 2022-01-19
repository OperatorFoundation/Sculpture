//
//  ParticleMemoryStore.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/26/21.
//

import Foundation

public class ParticleMemoryStore: ParticleStore
{
    public var root: ParticleStoreLens
    {
        return []
    }

    var particle: Particle

    public init(particle: Particle)
    {
        self.particle = particle
    }

    public func put(path: ParticleStoreLens, particle newParticle: Particle) -> Bool
    {
        guard let result = put(path: path, newParticle: newParticle, oldParticle: self.particle) else {return false}
        self.particle = result
        return true
    }

    func put(path: ParticleStoreLens, newParticle: Particle, oldParticle: Particle) -> Particle?
    {
        if path.isEmpty
        {
            return newParticle
        }
        else
        {
            guard let index = path.first else {return nil}
            let newPath = [Int](path.dropFirst())

            guard var particles = particle.compound else {return nil}
            guard index > 0 && index < particles.count else {return nil}
            let oldSubParticle = particles[index]
            guard let newSubParticle = put(path: newPath, newParticle: newParticle, oldParticle: oldSubParticle) else {return nil}
            particles[index] = newSubParticle
            return .compound(particles)
        }
    }

    public func get(path: ParticleStoreLens) -> Particle?
    {
        var currentParticle = self.particle

        for item in path
        {
            switch currentParticle
            {
                case .atom(_):
                    return nil
                case .compound(let array):
                    guard item >= 0 && item < array.count else {return nil}
                    currentParticle = array[item]
            }
        }

        return currentParticle
    }

    public func count(path: ParticleStoreLens) -> Int
    {
        let currentParticle = self.get(path: path)
        switch currentParticle
        {
            case .atom(_):
                return 0
            case .compound(let particles):
                return particles.count
            case nil:
                return 0
        }
    }

    public func isAtom(path: ParticleStoreLens) -> Bool
    {
        let currentParticle = self.get(path: path)
        switch currentParticle
        {
            case .atom(_):
                return true
            case .compound(_):
                return false
            case nil:
                return false
        }
    }
}
