//
//  TextStructure.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/10/21.
//

import Foundation

public indirect enum StructureText
{
    case line(Line)
    case block(Block)
    case list([StructureText])
}

public struct Line
{
    let name: String
    let parameters: [String]
}

public struct Block
{
    let line: Line
    let inner: StructureText
}

protocol Textable
{
    init?(structureText: StructureText)
    var structureText: StructureText {get}
}
