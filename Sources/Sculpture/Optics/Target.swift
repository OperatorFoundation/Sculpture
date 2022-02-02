//
//  Target.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/26/22.
//

import Foundation

public protocol Target
{
    associatedtype Index

    func get(lens: Lens<Self>) throws -> Self
    func count(lens: Lens<Self>) throws -> Int
    func set(lens: Lens<Self>, _ newTree: Self) throws -> Self
    func isLeaf(lens: Lens<Self>) throws -> Bool
}
