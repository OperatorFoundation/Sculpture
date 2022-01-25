//
//  Optics.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/14/22.
//

import Foundation

typealias SymbolLens = Lens<SymbolTree>
//public struct SymbolLens
//{
//    public let path: [Symbol]
//
//    public var isEmpty: Bool
//    {
//        return self.path.isEmpty
//    }
//
//    public init()
//    {
//        self.path = []
//    }
//
//    public init(_ path: [Symbol])
//    {
//        self.path = path
//    }
//
//    public func pop() -> (Symbol, SymbolLens)?
//    {
//        guard let symbol = self.path.first else {return nil}
//        let rest = [Symbol](self.path.dropFirst())
//        return (symbol, SymbolLens(rest))
//    }
//
//    public func narrow(_ symbol: Symbol) -> SymbolLens
//    {
//        var newPath = self.path
//        newPath.append(symbol)
//
//        return SymbolLens(newPath)
//    }
//
//    public func broaden() -> SymbolLens
//    {
//        var newPath = self.path
//        newPath.remove(at: newPath.count-1)
//
//        return SymbolLens(newPath)
//    }
//
//    public func focus(_ tree: SymbolTree) -> Focus<SymbolTree>?
//    {
//        return Focus<SymbolTree>(lens: self, tree: tree)
//    }
//}

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
                            guard let int = index.int else {throw LensError.badLens(lens)}
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
                    guard let int = index.int else {throw LensError.badLens(lens)}
                    maybeSubtree = lexicon.get(index: int)
            }
            guard let subtree = maybeSubtree else {throw LensError.badLens(lens)}

            guard let newSubtree = subtree.set(newLens, newTree) else {throw LensError.badLens(lens)}
            switch symbol
            {
                case .word(let word):
                    guard lexicon.set(key: word, value: newSubtree) else {throw LensError.badLens(lens)}
                case .index(let index):
                    guard let int = index.int else {throw LensError.badLens(lens)}
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

//public struct SymbolFocus
//{
//    let lens: SymbolLens
//    let tree: SymbolTree
//
//    public init?(tree: SymbolTree)
//    {
//        self.tree = tree
//
//        self.lens = SymbolLens()
//
//        guard self.isValid() else {return nil}
//    }
//
//    public init?(lens: SymbolLens, tree: SymbolTree)
//    {
//        self.lens = lens
//        self.tree = tree
//
//        guard self.isValid() else {return nil}
//    }
//
//    public func get() -> SymbolTree?
//    {
//        return self.tree.get(self.lens)
//    }
//
//    public func set(_ tree: SymbolTree) -> SymbolTree?
//    {
//        return self.tree.set(self.lens, tree)
//    }
//
//    public func count() -> Int?
//    {
//        return self.tree.count(self.lens)
//    }
//
//    public func isAtom() -> Bool?
//    {
//        return self.tree.isAtom(self.lens)
//    }
//
//    public func isValid() -> Bool
//    {
//        return self.get() != nil
//    }
//
//    public func narrow(_ symbol: Symbol) -> SymbolFocus?
//    {
//        let newLens = self.lens.narrow(symbol)
//        guard let newFocus = SymbolFocus(lens: newLens, tree: self.tree) else {return nil}
//        return newFocus
//    }
//
//    public func broaden() -> SymbolFocus?
//    {
//        let newLens = self.lens.broaden()
//        guard let newFocus = SymbolFocus(lens: newLens, tree: self.tree) else {return nil}
//        return newFocus
//    }
//
//    public func unfocus() -> SymbolLens
//    {
//        return self.lens
//    }
//}
