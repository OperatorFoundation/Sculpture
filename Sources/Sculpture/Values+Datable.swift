//
//  Values+Datable.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/6/21.
//

import Foundation
import Datable

extension Value: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}

        let typeByte = data[0]
        guard let type = Values(rawValue: typeByte) else {return nil}

        let rest = Data(data[1...])

        switch type
        {
            case .basic:
                guard let value = BasicValue(data: rest) else {return nil}
                self = .basic(value)
            case .structure:
                guard let value = StructureInstance(data: rest) else {return nil}
                self = .structure(value)
            case .choice:
                guard let value = OptionValue(data: rest) else {return nil}
                self = .choice(value)
            case .sequence:
                guard let value = SequenceValue(data: rest) else {return nil}
                self = .sequence(value)
        }
    }

    public var data: Data
    {
        switch self
        {
            case .basic(let value):
                return Values.basic.rawValue.data + value.data
            case .structure(let value):
                return Values.structure.rawValue.data + value.data
            case .choice(let value):
                return Values.choice.rawValue.data + value.data
            case .sequence(let value):
                return Values.sequence.rawValue.data + value.data
        }
    }
}

extension SequenceValue: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (type, rest) = sliceDataToString(data) else {return nil}
        self.type = type

        guard let contents: [Value] = dataToList(rest) else {return nil}
        self.contents = contents
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.type))
        result.append(listToData(self.contents, totalCount: false, itemCount: true))

        return result
    }
}

extension StructureInstance: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (type, rest) = sliceDataToString(data) else {return nil}
        self.type = type

        guard let values: [PropertyValue] = dataToList(rest) else {return nil}
        self.values = values
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.type))
        result.append(listToData(self.values, totalCount: false, itemCount: true))

        return result
    }
}

extension PropertyValue: MaybeDatable
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
                guard let value = BasicValue(data: rest) else {return nil}
                self = .basic(value)
            case .choice:
                guard let value = OptionValue(data: rest) else {return nil}
                self = .choice(value)
            case .sequence:
                guard let values: [PropertyValue] = dataToList(rest) else {return nil}
                self = .sequence(values)
            case .structure:
                guard let value = StructureInstance(data: rest) else {return nil}
                self = .structure(value)
            case .reference:
                guard let value = ReferenceValue(data: rest) else {return nil}
                self = .reference(value)
        }
    }

    public var data: Data
    {
        var result = Data()

        switch self
        {
            case .basic(let basic):
                result.append(Types.basic.rawValue)
                result.append(basic.data)
            case .structure(let instance):
                result.append(Types.structure.rawValue)
                result.append(instance.data)
            case .sequence(let values):
                result.append(Types.sequence.rawValue)
                result.append(listToData(values))
            case .choice(let option):
                result.append(Types.choice.rawValue)
                result.append(option.data)
            case .reference(let reference):
                result.append(Types.reference.rawValue)
                result.append(reference.data)
        }

        return result
    }
}

extension OptionValue: MaybeDatable
{
    public init?(data: Data)
    {
        guard let (choice, rest) = sliceDataToString(data) else {return nil}
        self.choice = choice

        guard let (chosen, remainder) = sliceDataToString(rest) else {return nil}
        self.chosen = chosen

        guard let values: [PropertyValue] = dataToList(remainder) else {return nil}
        self.values = values
    }

    public var data: Data
    {
        var result = Data()

        result.append(stringToData(self.choice))
        result.append(stringToData(self.chosen))
        result.append(listToData(self.values))

        return result
    }
}

extension BasicValue: MaybeDatable
{
    public init?(data: Data)
    {
        guard data.count > 1 else {return nil}
        let typeByte = data[0]
        let value = Data(data[1...])

        guard let type = BasicTypes(rawValue: typeByte) else {return nil}
        switch type
        {
            case .string:
                self = .string(value.string)
            case .uint:
                guard let uint = value.maybeNetworkUint64 else {return nil}
                self = .uint(uint)
            default:
                // FIXME
                return nil
        }
    }

    public var data: Data
    {
        var result = Data()

        switch self
        {
            case .string(let string):
                result.append(BasicTypes.string.rawValue.maybeNetworkData!)
                result.append(string.data)
                return result
            case .uint(let uint):
                result.append(BasicTypes.uint.rawValue.maybeNetworkData!)
                result.append(uint.maybeNetworkData!)
                return result
            default:
                // FIXME
                return result
        }
    }
}

extension ReferenceValue: MaybeDatable
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
