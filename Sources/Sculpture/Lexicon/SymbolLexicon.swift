//
//  SymbolLexicon.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/5/22.
//

import Foundation
import Abacus
import Rainbow

public typealias SymbolLexicon = Lexicon<Word,SymbolTree,Word>

public func resolve(context: Focus<SymbolTree>, symbol: Word) throws -> Focus<SymbolTree>?
{
    let tree = try context.get()
    switch tree
    {
        case .atom(_):
            let newFocus = try context.broaden()
            return try resolve(context: newFocus, symbol: symbol)
        case .lexicon(_):
            if let newFocus = try? context.narrow(.word(symbol))
            {
                return newFocus
            }
            else
            {
                let newFocus = try context.broaden()
                return try resolve(context: newFocus, symbol: symbol)
            }
    }
}

extension SymbolLexicon
{
    public convenience init(top: [ParserTree]) throws
    {
        // Convert each top-level tree into an element
        let elements = try top.map
        {
            (parserTree: ParserTree) -> (Word?, SymbolTree) in

            // Convert each top-level chunk to an element in the top-level lexicon.
            // Top-level trees should all be lists.
            guard let subtrees = parserTree.trees else {throw SymbolicError.badSymbol(parserTree.token!)}

            // A top-level subtree can be a list or a binding
            guard let first = subtrees.first else {throw ParserError.emptyTokens}
            let rest = [ParserTree](subtrees.dropFirst())

            if let token = first.token
            {
                // First element was a token. It could be a binding or start of the list.
                let type = token.type!

                switch type
                {
                    case .atomicValue(let value):
                        switch value
                        {
                            case .word(_):
                                let lexicon = try SymbolLexicon(trees: subtrees)
                                return (nil, .lexicon(lexicon))
                            case .number(_):
                                let lexicon = try SymbolLexicon(trees: subtrees)
                                return (nil, .lexicon(lexicon))
                            case .data(_):
                                let lexicon = try SymbolLexicon(trees: subtrees)
                                return (nil, .lexicon(lexicon))
                        }
                    case .bindingSymbol(let word):
                        let sublexicon = try SymbolLexicon(trees: rest)
                        return (word, .lexicon(sublexicon))
                }
            }
            else
            {
                // First element was a tree. So it's not a binding and has no head.
                let subelements = try SymbolLexicon.treesToElements(subtrees)
                let lexicon = SymbolLexicon(elements: subelements)
                return (nil, .lexicon(lexicon))
            }
        }

        // Top-level trees form a lexicon with no head
        self.init(elements: elements)
        return
    }

    public convenience init(trees: [ParserTree]) throws
    {
        // A top-level subtree can be a list or a binding
        guard let first = trees.first else {throw ParserError.emptyTokens}
        let rest = [ParserTree](trees.dropFirst())

        if let token = first.token
        {
            // First element was a token. It could be a binding or start of the list.
            let type = token.type!

            switch type
            {
                case .atomicValue(_):
                    let elements = try SymbolLexicon.treesToElements(trees)
                    self.init(elements: elements)
                    return
                case .bindingSymbol(let binding):
                    var elements = try SymbolLexicon.treesToElements(rest)
                    let (_, value) = elements[0]
                    elements[0] = (binding, value)
                    self.init(elements: elements)
            }
        }
        else
        {
            // First element was a tree. So it's not a binding and has no head.
            let elements = try SymbolLexicon.treesToElements(trees)
            self.init(elements: elements)
        }
    }

    // Explicit headless, trees do not have a head
    static func treesToElements(_ trees: [ParserTree]) throws -> [(Word?, SymbolTree)]
    {
        var elements: [(Word?, SymbolTree)] = []

        for tree in trees
        {
            switch tree
            {
                case .token(let token):
                    let value = token.type!.atomicValue!
                    elements.append((nil, .atom(value)))
                case .trees(let subtrees):
                    let lexicon = try SymbolLexicon(trees: subtrees)
                    elements.append((nil, .lexicon(lexicon)))
            }
        }

        return elements
    }
}

extension SymbolLexicon: CustomStringConvertible
{
    public var description: String
    {
        var result: String = ""

        result.append("(")
        for (maybeWord, tree) in self.elements()
        {
            if let word = maybeWord
            {
                result.append(word.string)
                result.append(":")
                result.append(" ")
            }

            result.append(tree.description)
        }
        result.append(")")

        return result
    }

    public func display()
    {
        print("(".lightYellow, terminator: "")
        var first = true
        for (maybeWord, tree) in self.elements()
        {
            if let word = maybeWord
            {
                print(word.string.magenta, terminator: "")
                print(":".lightMagenta, terminator: "")
                print(" ", terminator: "")
            }

            tree.display(first)
            if first {first = false}
        }
        print(")".lightYellow, terminator: "")
    }
}

public enum SymbolicError: Error
{
    case badSymbol(Token)
}
