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

    public func get(lens: Lens<Self>) throws -> Self
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
            return try subtree.get(lens: newLens)
        }
    }

    public func count(lens: Lens<Self>) throws -> Int
    {
        let subtree = try self.get(lens: lens)
        switch subtree
        {
            case .token(_):
                return 0
            case .trees(let trees):
                return trees.count
        }
    }

    public func set(lens: Lens<Self>, _ newTree: Self) throws -> Self
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
            let newSubtree = try subtree.set(lens: newLens, newTree)
            trees[symbol]=newSubtree
            return .trees(trees)
        }
    }

    public func isLeaf(lens: Lens<Self>) throws -> Bool
    {
        let subtree = try self.get(lens: lens)
        return subtree.token != nil
    }
}
