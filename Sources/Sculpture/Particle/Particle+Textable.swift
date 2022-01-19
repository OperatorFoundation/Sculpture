//
//  Particle+Textable.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/26/21.
//

import Foundation
import SwiftHexTools

extension Particle: Textable
{
    public init?(structureText: StructureText)
    {
        guard let particle = structureText.particle else {return nil}
        self = particle
        return
    }

    public var structureText: StructureText
    {
        return StructureText(particle: self)!
    }
}

func escape(_ string: String) -> String
{
    let pattern = #"[\W\s]+"#
    if pattern.range(of: pattern, options: .regularExpression) != nil
    {
        return "0x" + string.data.hex
    }
    else if string.starts(with: "0x")
    {
        return "0x" + string.data.hex
    }
    else
    {
        return string
    }
}

func unescape(_ string: String) -> String?
{
    if string.starts(with: "0x")
    {
        let substring = String(string[string.index(string.startIndex, offsetBy: 2)..<string.endIndex])
        guard let data = Data(hex: substring) else {return nil}
        return data.string
    }
    else
    {
        return string
    }
}
