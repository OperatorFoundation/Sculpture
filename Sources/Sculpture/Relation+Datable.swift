//
//  Relation+Datable.swift
//  
//
//  Created by Dr. Brandon Wiley on 11/16/21.
//

import Foundation
import Datable

extension Relation: MaybeDatable
{
    public init?(data: Data)
    {
        let typeByte = data[0]
        let remainder = Data(data[1...])

        guard let relation = Relations(rawValue: typeByte) else {return nil}
        switch relation
        {
            case .implements:
                guard let relation = Implements(data: remainder) else {return nil}
                self = .implements(relation)
            case .inherits:
                guard let relation = Inherits(data: remainder) else {return nil}
                self = .inherits(relation)
        }
    }

    public var data: Data
    {
        switch self
        {
            case .implements(let relation):
                return Relations.implements.rawValue.data + relation.data
            case .inherits(let relation):
                return Relations.inherits.rawValue.data + relation.data
        }
    }
}

extension Implements: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (instance, rest): (Type, Data) = sliceDataToListItem(data) else {return nil}
        self.instance = instance

        guard let interface = Type(data: rest) else {return nil}
        self.interface = interface
    }

    public var data: Data
    {
        var result = Data()

        let instanceData = instance.data
        result.append(dataToCountData(instanceData) + instanceData)
        result.append(interface.data)

        return result
    }
}

extension Inherits: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (subclass, rest): (Type, Data) = sliceDataToListItem(data) else {return nil}
        self.subclass = subclass

        guard let superclass = Type(data: rest) else {return nil}
        self.superclass = superclass
    }

    public var data: Data
    {
        var result = Data()

        let subclassData = self.subclass.data
        result.append(dataToCountData(subclassData) + subclassData)
        result.append(self.superclass.data)

        return result
    }
}
