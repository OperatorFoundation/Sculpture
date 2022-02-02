//
//  Focus.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/26/22.
//

import Foundation

public struct Focus<Tree> where Tree: Target
{
    let lens: Lens<Tree>
    let tree: Tree

    public init(tree: Tree) throws
    {
        self.tree = tree

        self.lens = Lens<Tree>()

        guard self.isValid() else {throw LensError<Tree>.badLens(self.lens)}
    }

    public init(lens: Lens<Tree>, tree: Tree) throws
    {
        self.lens = lens
        self.tree = tree

        guard self.isValid() else {throw LensError<Tree>.badLens(self.lens)}
    }

    public func get() throws -> Tree
    {
        return try self.tree.get(lens: self.lens)
    }

    public func set(_ tree: Tree) throws -> Focus<Tree>
    {
        let newTree = try self.tree.set(lens: self.lens, tree)
        return try Focus<Tree>(lens: self.lens, tree: newTree)
    }

    public func count() throws -> Int
    {
        return try self.tree.count(lens: self.lens)
    }

    public func isLeaf() throws -> Bool
    {
        return try self.tree.isLeaf(lens: self.lens)
    }

    public func isValid() -> Bool
    {
        do
        {
            let _ = try self.get()
            return true
        }
        catch
        {
            return false
        }
    }

    public func narrow(_ symbol: Tree.Index) throws -> Focus<Tree>
    {
        let newLens = self.lens.narrow(symbol)
        let newFocus = try Focus<Tree>(lens: newLens, tree: self.tree)
        return newFocus
    }

    public func broaden() throws -> Focus<Tree>
    {
        let newLens = self.lens.broaden()
        let newFocus = try Focus<Tree>(lens: newLens, tree: self.tree)
        return newFocus
    }

    public func unfocus() -> Lens<Tree>
    {
        return self.lens
    }
}
