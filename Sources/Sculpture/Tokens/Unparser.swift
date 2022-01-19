//
//  Parser.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/14/22.
//

import Foundation

extension Parser
{
    public convenience init(_ symbolTree: SymbolTree) throws
    {
        let parserTree = try Parser.parseTreeFromSymbols(symbolTree)
        try self.init(parserTree)
    }

    static func parseTreeFromSymbols(_ symbolTree: SymbolTree) throws -> ParserTree
    {
        let position = TokenPosition()
        let (result, _) = try Parser.parseTreeFromSymbols(symbolTree, position)
        return result
    }

    static func parseTreeFromSymbols(_ symbolTree: SymbolTree, _ position: TokenPosition) throws -> (ParserTree, TokenPosition)
    {
        var newPosition = position
        switch symbolTree
        {
            case .atom(let atomicValue):
                let type = LexicalType.atomicValue(atomicValue)
                let string = atomicValue.description
                let token = Token(start: newPosition, string: string, type: type)

                newPosition.index += string.count + 1
                newPosition.width += string.count + 1

                return (.token(token), newPosition)
            case .lexicon(let symbolLexicon):
                var trees: [ParserTree] = []

                for element in symbolLexicon.elements()
                {
                    let (maybeWord, tree) = element
                    if let word = maybeWord
                    {
                        let type = LexicalType.bindingSymbol(word)
                        let string = word.string+":"
                        let token = Token(start: position, string: string, type: type)
                        let atom = ParserTree.token(token)

                        var lineTrees: [ParserTree] = []
                        lineTrees.append(atom)

                        newPosition.index += string.count + 1
                        newPosition.width += string.count + 1

                        for (maybeSubWord, sublexicon) in tree.lexicon!.elements()
                        {
                            guard maybeSubWord == nil else {throw SymbolicError.badSymbol(Token(start: newPosition, string: maybeSubWord!.string))}

                            let (subtree, resultPosition) = try parseTreeFromSymbols(sublexicon, newPosition)
                            lineTrees.append(subtree)
                            newPosition = resultPosition
                        }

                        let line = ParserTree.trees(lineTrees)
                        trees.append(line)
                    }
                    else
                    {
                        let (subtree, resultPosition) = try Parser.parseTreeFromSymbols(nested: tree, position: newPosition)
                        trees.append(subtree)
                        newPosition = resultPosition
                    }
                }
                return (.trees(trees), newPosition)
        }
    }

    static public func parseTreeFromSymbols(nested: SymbolTree, position: TokenPosition) throws -> (ParserTree, TokenPosition)
    {
        var newPosition = position
        switch nested
        {
            case .atom(let atom):
                let type = LexicalType.atomicValue(atom)
                var string: String = ""
                switch atom
                {
                    case .word(let word):
                        string = word.string
                    case .number(let number):
                        string = number.string
                    case .data(let data):
                        string = "0x" + data.hex
                }
                let token = Token(start: position, string: string, type: type)
                return (.token(token), newPosition)
            case .lexicon(_):
                newPosition.height += 1
                newPosition.depth += 1
                newPosition.width = 0

                let (subtree, resultPosition) = try Parser.parseTreeFromSymbols(nested, newPosition)
                return (subtree, resultPosition)
        }
    }
}
