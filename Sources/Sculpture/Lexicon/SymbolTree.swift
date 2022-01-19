//
//  SymbolTree.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/14/22.
//

import Foundation

public indirect enum SymbolTree: Equatable
{
    case atom(AtomicValue)
    case lexicon(SymbolLexicon)
}

extension SymbolTree
{
    public func get(_ lens: SymbolLens) -> SymbolTree?
    {
        if lens.isEmpty
        {
            // Empty path requires a symbol
            guard let result = self.atom else {return nil}
            return .atom(result)
        }
        else
        {
            // Non-empty path requires a tree
            guard let tree = self.lexicon else {return nil}
            guard let (symbol, newLens) = lens.pop() else {return nil}
            switch symbol
            {
                case .word(let word):
                    guard let subtree = tree.get(key: word) else {return nil}
                    return subtree.get(newLens)
                case .index(let index):
                    guard let int = index.int else {return nil}
                    guard let subtree = tree.get(index: int) else {return nil}
                    return subtree.get(newLens)
            }
        }
    }

    public func count(_ lens: SymbolLens) -> Int?
    {
        guard let subtree = self.get(lens) else {return nil}
        switch subtree
        {
            case .atom(_):
                return 0
            case .lexicon(let lex):
                return lex.count
        }
    }

    public func set(_ lens: SymbolLens, _ newTree: SymbolTree) -> SymbolTree?
    {
        if lens.isEmpty
        {
            return newTree
        }
        else
        {
            guard let lex = self.lexicon else {return nil}
            guard let (symbol, newLens) = lens.pop() else {return nil}
            switch symbol
            {
                case .word(let word):
                    guard let subtree = lex.get(key: word) else {return nil}
                    guard let newSubtree = subtree.set(newLens, newTree) else {return nil}
                    guard lex.set(key: word, value: newSubtree) else {return nil}
                    return .lexicon(lex)

                case .index(let index):
                    guard let int = index.int else {return nil}
                    guard let subtree = lex.get(index: int) else {return nil}
                    guard let newSubtree = subtree.set(newLens, newTree) else {return nil}
                    guard lex.set(index: int, value: newSubtree) else {return nil}
                    return .lexicon(lex)
            }
        }
    }

    public func isAtom(_ lens: SymbolLens) -> Bool?
    {
        guard let subtree = self.get(lens) else {return nil}
        return subtree.atom != nil
    }
}

extension SymbolTree
{
    public var atom: AtomicValue?
    {
        get
        {
            switch self
            {
                case .atom(let atom):
                    return atom
                default:
                    return nil
            }
        }

        set(newValue)
        {
            if let value = newValue
            {
                self = .atom(value)
            }
        }
    }

    public var lexicon: SymbolLexicon?
    {
        get
        {
            switch self
            {
                case .lexicon(let lexicon):
                    return lexicon
                default:
                    return nil
            }
        }

        set(newValue)
        {
            if let value = newValue
            {
                self = .lexicon(value)
            }
        }
    }
}

extension SymbolTree
{
    public init(_ parserTree: ParserTree) throws
    {
        switch parserTree
        {
            case .token(let token):
                guard let type = token.type else {throw TokenizerError.tokenHasNoType(token.range.start)}
                switch type
                {
                    case .bindingSymbol(let word):
                        self = .lexicon(SymbolLexicon(elements: [(word, SymbolTree.lexicon(SymbolLexicon()))]))
                        return
                    case .atomicValue(let value):
                        self = .atom(value)
                        return
                }
            case .trees(let array):
                self = .lexicon(try SymbolLexicon(trees: array))
                return
        }
    }
}

extension SymbolTree: CustomStringConvertible
{
    public var description: String
    {
        var result = ""

        switch self
        {
            case .atom(let atom):
                switch atom
                {
                    case .word(let word):
                        result.append(word.string)
                        result.append(" ")
                    case .number(let number):
                        result.append(number.string)
                        result.append(" ")
                    case .data(let data):
                        result.append("0x")
                        result.append(data.hex)
                        result.append(" ")
                }
            case .lexicon(let lexicon):
                result.append(lexicon.description)
        }

        return result
    }
}
