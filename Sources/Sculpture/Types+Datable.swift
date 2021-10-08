//
//  File.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/6/21.
//

import Foundation
import Datable

extension Type: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}

        let typeByte = data[0]
        guard let type = Types(rawValue: typeByte) else {return nil}

        let rest = Data(data[1...])

        switch type
        {
            case .basic:
                guard let value = BasicType(data: rest) else {return nil}
                self = .basic(value)
            case .structure:
                guard let value = Structure(data: rest) else {return nil}
                self = .structure(value)
            case .choice:
                guard let value = Choice(data: rest) else {return nil}
                self = .choice(value)
            case .sequence:
                guard let value = Sequence(data: rest) else {return nil}
                self = .sequence(value)
            case .reference:
                guard let value = ReferenceType(data: rest) else {return nil}
                self = .reference(value)
        }
    }

    public var data: Data
    {
        switch self
        {
            case .basic(let value):
                return Types.basic.rawValue.data + value.data
            case .structure(let value):
                return Types.structure.rawValue.data + value.data
            case .sequence(let value):
                return Types.sequence.rawValue.data + value.data
            case .choice(let value):
                return Types.choice.rawValue.data + value.data
            case .reference(let value):
                return Types.reference.rawValue.data + value.data
        }
    }
}

extension Structure: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (name, rest) = sliceDataToString(data) else {return nil}
        self.name = name

        guard let properties: [Property] = dataToList(rest) else
        {
            self.properties = []
            return
        }
        self.properties = properties
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.name))
        result.append(listToData(self.properties, totalCount: false, itemCount: true))

        return result
    }
}

extension Option: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (name, rest) = sliceDataToString(data) else {return nil}
        self.name = name

        guard let typeList: [PropertyType] = dataToList(rest) else
        {
            self.types = []
            return
        }

        self.types = typeList
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.name))
        result.append(listToData(self.types, totalCount: false, itemCount: true))

        return result
    }
}

extension Property: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (name, rest) = sliceDataToString(data) else {return nil}
        self.name = name

        guard let type = PropertyType(data: rest) else {return nil}
        self.type = type
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.name))
        result.append(self.type.data)

        return result
    }
}

extension Sequence: MaybeDatable
{
    public init?(data: Data)
    {
        guard let type = Type(data: data) else {return nil}
        self.type = type
    }

    public var data: Data
    {
        return self.type.data
    }
}

extension Choice: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (name, rest) = sliceDataToString(data) else {return nil}
        self.name = name

        guard let optionList: [Option] = dataToList(rest) else
        {
            self.options = []
            return
        }

        self.options = optionList
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.name))
        result.append(listToData(self.options, totalCount: false, itemCount: true))

        return result
    }
}

extension PropertyType: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}

        let typeByte = data[0]
        let rest = Data(data[1...])
        guard let type = Types(rawValue: typeByte) else {return nil}


        switch type
        {
            case .basic:
                guard let basicType = BasicType(data: rest) else {return nil}
                self = .basic(basicType)
            case .structure:
                let typeName = rest.string
                self = .structure(typeName)
            case .sequence:
                let typeName = rest.string
                self = .sequence(typeName)
            case .choice:
                let typeName = rest.string
                self = .choice(typeName)
            default:
                return nil
        }
    }

    public var data: Data
    {
        var result = Data()

        switch self
        {
            case .basic(let basicType):
                result.append(Types.basic.rawValue.data)
                result.append(basicType.data)
            case .structure(let typeName):
                result.append(Types.structure.rawValue.data)
                result.append(typeName.data)
            case .sequence(let typeName):
                result.append(Types.sequence.rawValue.data)
                result.append(typeName.data)
            case .choice(let typeName):
                result.append(Types.choice.rawValue.data)
                result.append(typeName.data)
        }

        return result
    }
}

extension BasicType: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count == 1 else {return nil}

        let byte = data[0]
        guard let type = BasicTypes(rawValue: byte) else {return nil}

        switch type
        {
            case .string:
                self = .string
            case .uint:
                self = .uint
            case .int:
                self = .int
        }
    }

    public var data: Data
    {
        switch self
        {
            case .string:
                return BasicTypes.string.rawValue.data
            case .int:
                return BasicTypes.int.rawValue.data
            case .uint:
                return BasicTypes.uint.rawValue.data
        }
    }
}

extension ReferenceType: MaybeDatable
{
    public init?(data: Data)
    {
        self.name = data.string
    }

    public var data: Data
    {
        return self.name.data
    }
}
