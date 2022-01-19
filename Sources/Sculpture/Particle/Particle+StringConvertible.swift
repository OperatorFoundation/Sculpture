//
//  Particle+StringConvertible.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/26/21.
//

import Foundation

extension Particle: CustomStringConvertible
{
    public var description: String
    {
        return self.structureText.description
    }
}

extension Particle: LosslessStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        guard let particle = text.particle else {return nil}
        self = particle
        return
    }
}
