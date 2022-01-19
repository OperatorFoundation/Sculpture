//
//  StructureText+Particleable.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/20/21.
//

import Foundation

extension StructureText: Particleable
{
    public init?(particle: Particle)
    {
        if let atom = particle.atom
        {
            self = .line(Line(name: atom, parameters: []))
            return
        }
        else if let compound = particle.compound
        {
            if compound.count == 0
            {
                return nil
            }
            else
            {
                let prefixAtoms = compound.prefix
                {
                    (particle: Particle) -> Bool in

                    return particle.atom != nil
                }

                let suffixAtoms = compound.drop
                {
                    (particle: Particle) -> Bool in

                    return particle.atom != nil
                }

                if prefixAtoms.count == compound.count
                {
                    // All atoms
                    let strings = prefixAtoms.compactMap
                    {
                        (particle: Particle) -> String? in

                        return particle.atom
                    }
                    guard strings.count == compound.count else {return nil}

                    if strings.count == 1
                    {
                        let first = strings[0]

                        self = .line(Line(name: first, parameters: []))
                        return
                    }
                    else
                    {
                        let first = strings[0]
                        let rest = [String](strings[1...])

                        self = .line(Line(name: first, parameters: rest))
                        return
                    }
                }
                else if prefixAtoms.count > 0
                {
                    // Some prefix atoms, block
                    let strings = prefixAtoms.compactMap
                    {
                        (particle: Particle) -> String? in

                        return particle.atom
                    }
                    guard strings.count == compound.count else {return nil}

                    if strings.count == 1
                    {
                        let first = strings[0]

                        let inner = suffixAtoms.compactMap
                        {
                            (particle: Particle) -> StructureText? in

                            return StructureText(particle: particle)
                        }
                        guard inner.count == suffixAtoms.count else {return nil}

                        self = .block(Block(line: Line(name: first, parameters: [
                        ]), inner: .list(inner)))
                        return
                    }
                    else
                    {
                        let first = strings[0]
                        let rest = [String](strings[1...])

                        let inner = suffixAtoms.compactMap
                        {
                            (particle: Particle) -> StructureText? in

                            return StructureText(particle: particle)
                        }
                        guard inner.count == suffixAtoms.count else {return nil}

                        self = .block(Block(line: Line(name: first, parameters: rest), inner: .list(inner)))
                        return
                    }
                }
                else
                {
                    // No prefix atoms, list
                    let inner = suffixAtoms.compactMap
                    {
                        (particle: Particle) -> StructureText? in

                        return StructureText(particle: particle)
                    }
                    guard inner.count == suffixAtoms.count else {return nil}

                    self = .list(inner)
                }
            }
        }
        else
        {
            return nil
        }
    }

    public var particle: Particle?
    {
        switch self
        {
            case .line(let line):
                let head: Particle = .atom(line.name)

                if line.parameters.count == 0
                {
                    return head
                }
                else
                {
                    let rest: [Particle] = line.parameters.map
                    {
                        (string: String) -> Particle in

                        return Particle.atom(string)
                    }

                    return .compound([head]+rest)
                }

            case .block(let block):
                guard let prefix = StructureText.line(block.line).particle else {return nil}
                guard let suffix = block.inner.particle else {return nil}
                return .compound([prefix, suffix])

            case .list(let list):
                let particles = list.compactMap
                {
                    (text: StructureText) -> Particle? in

                    return text.particle
                }
                guard particles.count == list.count else {return nil}

                return .compound(particles)
        }
    }
}
