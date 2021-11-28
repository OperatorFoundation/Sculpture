//
//  Flow+LosslessStringConvertible.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/11/21.
//

import Foundation

extension Flow: LosslessStringConvertible, CustomStringConvertible
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
