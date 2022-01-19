//
//  Particle+Focus.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/20/21.
//

import Foundation
import Focus

extension Particle
{
    public var atom: String?
    {
        get
        {
            return self.atomPrism.tryGet(self)
        }

        set(newValue)
        {
            guard let newValue = newValue else {return}
            self = self.atomPrism.inject(newValue)
        }
    }

    public var compound: [Particle]?
    {
        get
        {
            return self.compoundPrism.tryGet(self)
        }

        set(newValue)
        {
            guard let newValue = newValue else {return}
            self = self.compoundPrism.inject(newValue)
        }
    }

    public var atomPrism: SimplePrism<Particle, String>
    {
        SimplePrism<Particle, String>(
            tryGet:
                {
                    (particle: Particle) -> String? in

                    switch particle
                    {
                        case .atom(let string):
                            return string
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (string: String) -> Particle in

                    return .atom(string)
                }
        )
    }

    public var compoundPrism: SimplePrism<Particle, [Particle]>
    {
        SimplePrism<Particle, [Particle]>(
            tryGet:
                {
                    (particle: Particle) -> [Particle]? in

                    switch particle
                    {
                        case .compound(let particles):
                            return particles
                        default:
                            return nil
                    }
                },

            inject:
                {
                    (particles: [Particle]) -> Particle in

                    return .compound(particles)
                }
        )
    }
}
