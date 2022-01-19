//
//  Particle.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/20/21.
//

import Foundation

public protocol Particleable
{
    init?(particle: Particle)

    var particle: Particle? {get}
}

public enum Particle
{
    case atom(String)
    case compound([Particle])
}
