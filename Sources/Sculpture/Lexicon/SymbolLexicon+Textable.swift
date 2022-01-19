//
//  SymbolLexicon+Textable.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/9/22.
//

import Foundation
import SwiftHexTools

extension SymbolTree: Particleable
{
    public var particle: Particle?
    {
        switch self
        {
            case .atom(let atom):
                switch atom
                {
                    case .word(let word):
                        return .atom(word.string)
                    case .number(let number):
                        return .atom(number.string)
                    case .data(let data):
                        return .atom("0x"+data.hex)
                }
            case .lexicon(let lexicon):
                let particles = lexicon.elements().compactMap
                {
                    (maybeWord: Word?, tree: SymbolTree) -> Particle? in

                    guard let particle = tree.particle else {return nil}

                    if let word = maybeWord
                    {
                        return .compound([
                            .atom(word.string+":"),
                            particle
                        ])
                    }
                    else
                    {
                        return particle
                    }
                }
                guard particles.count == lexicon.elements().count else {return nil}
                return .compound(particles)
        }
    }

    public init?(particle: Particle)
    {
        switch particle
        {
            case .atom(let string):
                guard let atom = AtomicValue(string) else {return nil}
                self = .atom(atom)
                return
            case .compound(let particles):
                let elements = particles.compactMap
                {
                    (particle: Particle) -> (Word?, SymbolTree)? in

                    switch particle
                    {
                        case .atom(_):
                            guard let result = SymbolTree(particle: particle) else {return nil}
                            return (nil, result)
                        case .compound(let subparticles):
                            guard let first = subparticles.first else {return nil}
                            switch first
                            {
                                case .atom(let string):
                                    guard let last = string.last else {return nil}
                                    if last == ":"
                                    {
                                        let start = string.startIndex
                                        let end = string.index(before: string.endIndex)
                                        let symbol = String(string[start..<end])
                                        let word = Word(symbol)
                                        let rest = [Particle](subparticles.dropFirst())
                                        if rest.count == 1
                                        {
                                            let item = rest[0]
                                            switch item
                                            {
                                                case .atom(_):
                                                    guard let tree = SymbolTree(particle: item) else {return nil}
                                                    return (word, tree)
                                                default:
                                                    let compound = Particle.compound(rest)
                                                    guard let tree = SymbolTree(particle: compound) else {return nil}
                                                    return (word, tree)
                                            }
                                        }
                                        else
                                        {
                                            let compound = Particle.compound(rest)
                                            guard let tree = SymbolTree(particle: compound) else {return nil}
                                            return (word, tree)
                                        }
                                    }
                                    else
                                    {
                                        guard let tree = SymbolTree(particle: particle) else {return nil}
                                        return (nil, tree)
                                    }
                                case .compound(_):
                                    guard let tree = SymbolTree(particle: particle) else {return nil}
                                    return (nil, tree)
                            }
                    }
                }
                guard elements.count == particles.count else {return nil}

                let lex = SymbolLexicon(elements: elements)
                self = .lexicon(lex)
                return
        }
    }
}

//extension SymbolTree: Textable
//{
//    public var structureText: StructureText
//    {
//        switch self
//        {
//            case .atom(let atom):
//                switch atom
//                {
//                    case .word(let word):
//                        return .line(Line(name: word.string, parameters: []))
//                    case .number(let number):
//                        return .line(Line(name: number.string, parameters: []))
//                    case .data(let data):
//                        let string = escape(data)
//                        return .line(Line(name: string, parameters: []))
//                }
//            case .lexicon(let lexicon):
//                let texts = lexicon.elements().map
//                {
//                    (maybeWord: Word?, tree: SymbolTree) -> StructureText in
//
//                    <#code#>
//                }
//        }
//    }
//
//    public required init?(structureText: StructureText)
//    {
//        <#code#>
//    }
//}
