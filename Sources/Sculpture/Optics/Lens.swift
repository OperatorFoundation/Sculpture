//
//  Lens.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/26/22.
//

import Foundation

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

public enum LensError<Tree>: Error where Tree: Target
{
    case badLens(Lens<Tree>)
}
