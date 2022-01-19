//
//  Optics.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/14/22.
//

import Foundation

extension ParserTree: Target
{
    public typealias Index = Int

    public func get(_ lens: Lens<Self>) throws -> Self
    {
        if lens.isEmpty
        {
            return self
        }
        else
        {
            // Non-empty path requires a tree for each item in the path
            guard let trees = self.trees else {throw LensError<Self>.badLens(lens)}
            guard let (symbol, newLens) = lens.pop() else {throw LensError<Self>.badLens(lens)}
            guard symbol >= 0 && symbol < trees.count else {throw LensError<Self>.badLens(lens)}
            let subtree = trees[symbol]
            return try subtree.get(newLens)
        }
    }

    public func count(_ lens: Lens<Self>) throws -> Int
    {
        let subtree = try self.get(lens)
        switch subtree
        {
            case .token(_):
                return 0
            case .trees(let trees):
                return trees.count
        }
    }

    public func set(_ lens: Lens<Self>, _ newTree: Self) throws -> Self
    {
        if lens.isEmpty
        {
            return newTree
        }
        else
        {
            guard var trees = self.trees else {throw LensError<Self>.badLens(lens)}
            guard let (symbol, newLens) = lens.pop() else {throw LensError<Self>.badLens(lens)}
            guard symbol >= 0 && symbol < trees.count else {throw LensError<Self>.badLens(lens)}
            let subtree = trees[symbol]
            let newSubtree = try subtree.set(newLens, newTree)
            trees[symbol]=newSubtree
            return .trees(trees)
        }
    }

    public func isLeaf(_ lens: Lens<Self>) throws -> Bool
    {
        let subtree = try self.get(lens)
        return subtree.token != nil
    }
}

public struct Lens<Tree> where Tree: Target
{
    public let path: [Tree.Index]

    public var isEmpty: Bool
    {
        return self.path.isEmpty
    }

    public init()
    {
        self.path = []
    }

    public init(_ path: [Tree.Index])
    {
        self.path = path
    }

    public func pop() -> (Tree.Index, Lens<Tree>)?
    {
        guard let symbol = self.path.first else {return nil}
        let rest = [Tree.Index](self.path.dropFirst())
        return (symbol, Lens<Tree>(rest))
    }

    public func narrow(_ symbol: Tree.Index) -> Lens<Tree>
    {
        var newPath = self.path
        newPath.append(symbol)

        return Lens<Tree>(newPath)
    }

    public func broaden() -> Lens<Tree>
    {
        var newPath = self.path
        newPath.remove(at: newPath.count-1)

        return Lens<Tree>(newPath)
    }

    public func focus(_ tree: Tree) throws -> Focus<Tree>
    {
        return try Focus(lens: self, tree: tree)
    }
}

public protocol Target
{
    associatedtype Index

    func get(_ lens: Lens<Self>) throws -> Self
    func count(_ lens: Lens<Self>) throws -> Int
    func set(_ lens: Lens<Self>, _ newTree: Self) throws -> Self
    func isLeaf(_ lens: Lens<Self>) throws -> Bool
}

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
        return try self.tree.get(self.lens)
    }

    public func set(_ tree: Tree) throws -> Focus<Tree>
    {
        let newTree = try self.tree.set(self.lens, tree)
        return try Focus<Tree>(lens: self.lens, tree: newTree)
    }

    public func count() throws -> Int
    {
        return try self.tree.count(self.lens)
    }

    public func isLeaf() throws -> Bool
    {
        return try self.tree.isLeaf(self.lens)
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

public enum LensError<Tree>: Error where Tree: Target
{
    case badLens(Lens<Tree>)
}
