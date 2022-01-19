//
//  Optics.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/14/22.
//

import Foundation

public struct SymbolLens
{
    public let path: [Symbol]

    public var isEmpty: Bool
    {
        return self.path.isEmpty
    }

    public init()
    {
        self.path = []
    }

    public init(_ path: [Symbol])
    {
        self.path = path
    }

    public func pop() -> (Symbol, SymbolLens)?
    {
        guard let symbol = self.path.first else {return nil}
        let rest = [Symbol](self.path.dropFirst())
        return (symbol, SymbolLens(rest))
    }

    public func narrow(_ symbol: Symbol) -> SymbolLens
    {
        var newPath = self.path
        newPath.append(symbol)

        return SymbolLens(newPath)
    }

    public func broaden() -> SymbolLens
    {
        var newPath = self.path
        newPath.remove(at: newPath.count-1)

        return SymbolLens(newPath)
    }

    public func focus(_ tree: SymbolTree) -> SymbolFocus?
    {
        return SymbolFocus(lens: self, tree: tree)
    }
}

public struct SymbolFocus
{
    let lens: SymbolLens
    let tree: SymbolTree

    public init?(tree: SymbolTree)
    {
        self.tree = tree

        self.lens = SymbolLens()

        guard self.isValid() else {return nil}
    }

    public init?(lens: SymbolLens, tree: SymbolTree)
    {
        self.lens = lens
        self.tree = tree

        guard self.isValid() else {return nil}
    }

    public func get() -> SymbolTree?
    {
        return self.tree.get(self.lens)
    }

    public func set(_ tree: SymbolTree) -> SymbolTree?
    {
        return self.tree.set(self.lens, tree)
    }

    public func count() -> Int?
    {
        return self.tree.count(self.lens)
    }

    public func isAtom() -> Bool?
    {
        return self.tree.isAtom(self.lens)
    }

    public func isValid() -> Bool
    {
        return self.get() != nil
    }

    public func narrow(_ symbol: Symbol) -> SymbolFocus?
    {
        let newLens = self.lens.narrow(symbol)
        guard let newFocus = SymbolFocus(lens: newLens, tree: self.tree) else {return nil}
        return newFocus
    }

    public func broaden() -> SymbolFocus?
    {
        let newLens = self.lens.broaden()
        guard let newFocus = SymbolFocus(lens: newLens, tree: self.tree) else {return nil}
        return newFocus
    }

    public func unfocus() -> SymbolLens
    {
        return self.lens
    }
}
