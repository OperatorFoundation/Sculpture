//
//  SymbolLexicon+String.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/25/22.
//

import Foundation

extension SymbolTree
{
    public func string() throws -> String
    {
        // Top must be Lexicon
        guard let lexicon = self.lexicon else {throw ParserError.emptyTokens}
        let strings = try lexicon.elements().map
        {
            (maybeWord: Word?, tree: SymbolTree) -> String in

            guard let lexicon = tree.lexicon else
            {
                throw ParserError.emptyTokens
            }

            if let word = maybeWord
            {
                var result = ""
                result.append(word.string)
                result.append(":")
                result.append(try lexicon.string(depth: 0, inline: true))
                return result
            }
            else
            {
                return try lexicon.string(depth: 0, inline: false)
            }
        }

        return strings.joined()
    }
}

extension SymbolLexicon
{
    public func string(depth: Int, inline: Bool = false) throws -> String
    {
        var result = ""
        var inline = inline

        for (maybeWord, tree) in self.elements()
        {
            if inline
            {
                // Binding must be first
                if let word = maybeWord {throw SymbolicError.badSymbol(Token(start: TokenPosition(), string: word.string))}

                switch tree
                {
                    case .atom(let atom):
                        result.append(" ")
                        result.append(atom.string)
                    case .lexicon(let lexicon):
                        result.append("\n")
                        result.append(try lexicon.string(depth: depth + 1))

                        inline = false
                }
            }
            else
            {
                if let word = maybeWord
                {
                    for _ in 0..<depth
                    {
                        result.append("\t")
                    }

                    result.append(word.string)
                    result.append(":")

                    inline = true
                }

                switch tree
                {
                    case .atom(let atom):
                        if inline
                        {
                            result.append(" ")
                        }
                        else
                        {
                            for _ in 0..<depth
                            {
                                result.append("\t")
                            }
                        }

                        result.append(atom.string)
                        inline = true
                    case .lexicon(let lexicon):
                        if inline
                        {
                            result.append("\n")
                        }

                        result.append(try lexicon.string(depth: depth + 1))
                        inline = false
                }
            }
        }

        let end = result.index(before: result.endIndex)
        if result[end] != "\n"
        {
            result.append("\n")
        }

        return result
    }
}

