//
//  SymbolLexicon.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/5/22.
//

import Foundation
import Abacus
import AST

public typealias SymbolLexicon = Lexicon<Word,SymbolTree,AtomicValue>

extension SymbolLexicon
{
    // Top level, each subtree in top may or may not contain a head
    // However, the list of trees does not itself have a head.
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
                        let lexicon = try SymbolLexicon(head: value, trees: rest)
                        return (nil, .lexicon(lexicon))
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

    // Explicit head, trees do not contain a head
    public convenience init(head: AtomicValue, trees: [ParserTree]) throws
    {
        let elements = try SymbolLexicon.treesToElements(trees)
        self.init(head, elements: elements)
        return
    }

    // Implicit head, trees list may or may not have a head.
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
                case .atomicValue(let value):
                    try self.init(head: value, trees: rest)
                case .bindingSymbol(let word):
                    let elements = try SymbolLexicon.treesToElements(rest)
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

        if let head = self.head
        {
            switch head
            {
                case .word(let word):
                    result.append(word.string)
                    result.append("~")
                case .number(let number):
                    result.append(number.string)
                    result.append("~")
                case .data(let data):
                    result.append("0x")
                    result.append(data.hex)
                    result.append("~")
            }
        }

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
}

public enum SymbolicError: Error
{
    case badSymbol(Token)
}
