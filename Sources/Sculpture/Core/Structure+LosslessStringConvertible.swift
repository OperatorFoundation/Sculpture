//
//  Structure+LosslessStringConvertible.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/10/21.
//

import Foundation

extension Entity: LosslessStringConvertible, CustomStringConvertible
{
    public init?(_ description: String)
    {
        guard let text = StructureText(description) else {return nil}
        self.init(structureText: text)
    }

    public var description: String
    {
        let text = self.structureText
        return text.description
    }
}
