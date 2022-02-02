//
//  Optics.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/14/22.
//

import Foundation

typealias SymbolLens = Lens<SymbolTree>

extension SymbolTree: Target
{
    public typealias Index = Symbol

    public func get(lens: Lens<SymbolTree>) throws -> SymbolTree
    {
        if lens.isEmpty
        {
            return self
        }
        else
        {
            switch self
            {
                case .atom(_):
                    throw LensError.badLens(lens)
                case .lexicon(let lexicon):
                    guard let (symbol, newLens) = lens.pop() else {throw LensError.badLens(lens)}
                    switch symbol
                    {
                        case .word(let word):
                            guard let value = lexicon.get(key: word) else {throw LensError.badLens(lens)}
                            return try value.get(lens: newLens)
                        case .index(let index):
                            let int = index.int
                            guard let value = lexicon.get(index: int) else {throw LensError.badLens(lens)}
                            return try value.get(lens: newLens)
                    }
            }
        }
    }

    public func count(lens: Lens<SymbolTree>) throws -> Int
    {
        guard let tree = self.get(lens: lens) else {throw LensError.badLens(lens)}
        switch tree
        {
            case .atom(_):
                return 0
            case .lexicon(let lexicon):
                return lexicon.count
        }
    }

    public func set(lens: Lens<SymbolTree>, _ newTree: SymbolTree) throws -> SymbolTree
    {
        if lens.isEmpty
        {
            return newTree
        }
        else
        {
            guard let lexicon = self.lexicon else {throw LensError<Self>.badLens(lens)}
            guard let (symbol, newLens) = lens.pop() else {throw LensError<Self>.badLens(lens)}

            var maybeSubtree: SymbolTree? = nil
            switch symbol
            {
                case .word(let word):
                    maybeSubtree = lexicon.get(key: word)
                case .index(let index):
                    let int = index.int
                    maybeSubtree = lexicon.get(index: int)
            }
            guard let subtree = maybeSubtree else {throw LensError.badLens(lens)}

            guard let newSubtree = subtree.set(newLens, newTree) else {throw LensError.badLens(lens)}
            switch symbol
            {
                case .word(let word):
                    guard lexicon.set(key: word, value: newSubtree) else {throw LensError.badLens(lens)}
                case .index(let index):
                    let int = index.int
                    guard lexicon.set(index: int, key: nil, value: newSubtree) else {throw LensError.badLens(lens)}
            }

            return .lexicon(lexicon)
        }

    }

    public func isLeaf(lens: Lens<SymbolTree>) throws -> Bool
    {
        guard let tree = self.get(lens: lens) else {throw LensError.badLens(lens)}
        switch tree
        {
            case .atom(_):
                return true
            case .lexicon(_):
                return false
        }
    }
}

typealias SymbolFocus = Focus<SymbolTree>
